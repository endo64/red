Red [
	Title:	 "Red RPEL Console"
	Author:	 "Qingtian Xie"
	File:	 %console.red
	Tabs:	 4
	Icon:	 %app.ico
	Version: 0.0.1
	Needs:	 View
	Config:	 [gui-console?: yes red-help?: yes]
	Rights:  "Copyright (C) 2016 Qingtian Xie. All rights reserved."
]

#include %../console/engine.red
#include %highlight.red
#include %tips.red
#include %core.red

do [

ask: function [
	question [string!]
	return:  [string!]
][
	unless red-console-ctx/console/state [
		return "quit"
	]
	line: make string! 8
	line: insert line question
	vt: red-console-ctx/terminal
	vt/line: line
	vt/pos: 0
	vt/add-line line
	vt/ask?: yes
	vt/redraw vt/target
	do-events
	vt/ask?: no
	line
]

red-console-ctx: context [
	cfg-path:	none
	cfg:		none
	font:		make font! [name: font-fixed size: 11 color: 0.0.0]
	terminal:	make terminal! []

	console: make face! [
		type: 'base color: 0.0.128 offset: 0x0 size: 400x400
		flags:   [Direct2D editable scrollable all-over]
		options: [cursor: I-beam]
		menu: [
			"Copy^-Ctrl+C"		 copy
			"Paste^-Ctrl+V"		 paste
			"Select All^-Ctrl+A" select-all
		]
		actors: object [
			on-time: func [face [object!] event [event!]][
				caret/rate: 2
				face/rate: none
			]
			on-drawing: func [face [object!] event [event!]][
				terminal/paint
			]
			on-scroll: func [face [object!] event [event!]][
				terminal/scroll event
			]
			on-wheel: func [face [object!] event [event!]][
				terminal/scroll event
			]
			on-key: func [face [object!] event [event!]][
				terminal/press-key event
			]
			on-ime: func [face [object!] event [event!]][
				terminal/process-ime-input event
			]
			on-down: func [face [object!] event [event!]][
				terminal/mouse-down event
			]
			on-up: func [face [object!] event [event!]][
				terminal/mouse-up event
			]
			on-over: func [face [object!] event [event!]][
				terminal/mouse-move event
			]
			on-menu: func [face [object!] event [event!]][
				switch event/picked [
					copy		[probe 'TBD]
					paste		['TBD]
					select-all	['TBD]
				]
			]
		]

		init: func [/local box scroller][
			terminal/target: self
			box: terminal/box
			box/fixed?: yes
			box/target: self
			box/styles: make block! 200
			scroller: get-scroller self 'horizontal
			scroller/visible?: no						;-- hide horizontal bar
			scroller: get-scroller self 'vertical
			scroller/position: 1
			scroller/max-size: 2
			terminal/scroller: scroller
		]
	]

	caret: make face! [
		type: 'base color: 0.0.0.1 offset: 0x0 size: 1x17 rate: 2
		options: reduce ['caret console]
		actors: object [
			on-time: func [face [object!] event [event!]][
				face/color: either face/color = 0.0.0.1 [255.255.255.254][0.0.0.1]
			]
		]
	]
	tips: make tips! [visible?: no]

	fstk-logo: load/as 64#{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
		 wAAAABJRU5ErkJggg==
	} 'png

	display-about: function [][
		lay: layout/tight [
			title "About"
			size 360x330
			backdrop 58.58.60

			style text:  text 360 center 58.58.60 
			style txt:   text font-color white
			style small: txt  font [size: 9 color: white]
			style link:  text cursor 'hand all-over
				on-down [browse face/data]
				on-over [face/font/style: either event/away? [none]['underline]]

			below
			pad 0x15
			txt bold "Red Programming Language" font [size: 15 color: white]
			ver: txt font [size: 9 color: white]
			at 153x86 image fstk-logo
			at 0x160 small 360x20 "Copyright 2011-2017 - Fullstack Technologies"
			at 0x180 small 360x20 "and contributors."
			at 0x230 link "http://red-lang.org" font-size 10 font-color white
			at 0x260 link "http://github.com/red/red" font-size 10 font-color white
			at 154x300 button "Close" [unview win/selected: console]
			do [ver/text: form reduce ["Build" system/version #"-" system/build/date]]
		]
		center-face/with lay win
		view/flags lay [modal no-title]
	]

	show-cfg-dialog: function [][
		lay: layout [
			text "Buffer Lines:" cfg-buffers:	field return
			text "ForeColor:"	 cfg-forecolor: field return
			text "BackColor:"	 cfg-backcolor: field return
			button "OK" [
				if cfg/buffer-lines <> cfg-buffers/data [
					cfg/buffer-lines: cfg-buffers/data
				]
				cfg/font-color:   cfg-forecolor/data
				cfg/background:   cfg-backcolor/data
				unview
				win/selected: console
			]
			button "Cancel" [unview win/selected: console]
		]
		cfg-buffers/data: cfg/buffer-lines
		cfg-forecolor/data: cfg/font-color
		cfg-backcolor/data: cfg/background
		center-face/with lay win
		view/flags lay [modal]
	]

	apply-cfg: function [][
		win/offset:   cfg/win-pos
		win/size:     cfg/win-size
		font: make font! [
			name:  cfg/font-name
			size:  cfg/font-size
			color: cfg/font-color
		]
		console/font: font
		ft: copy font
		ft/color: white
		tips/font: ft
		terminal/update-cfg font cfg
	]

	save-cfg: function [][
		offset: win/offset					;-- offset could be negative in some cases
		if offset/x < 0 [offset/x: 0]
		if offset/y < 0 [offset/y: 0]
		cfg/win-pos:  offset
		cfg/win-size: win/size
		cfg/font-name: console/font/name
		cfg/font-size: console/font/size
		save/header cfg-path cfg [Purpose: "Red REPL Console Configuration File"]
	]

	load-cfg: func [/local cfg-dir][
		system/view/auto-sync?: no
		#either config/OS = 'Windows [
			cfg-dir: append to-red-file get-env "APPDATA" %/Red-Console/
		][
			cfg-dir: append to-red-file get-env "HOME" %/.Red-Console/
		]
		unless exists? cfg-dir [make-dir cfg-dir]
		cfg-path: append cfg-dir %console-cfg.red
		
		cfg: either exists? cfg-path [skip load cfg-path 2][
			compose [
				win-pos:	  (win/offset)
				win-size:	  (win/size)

				font-name:	  (font/name)
				font-size:	  11
				font-color:	  0.0.0
				background:	  252.252.252

				buffer-lines: 10000
			]
		]
		apply-cfg
		win/selected: console
		system/view/auto-sync?: yes
	]

	setup-faces: does [
		append win/pane reduce [console tips caret]
		win/menu: [
			"File" [
				"About"				about-msg
				---
				"Quit"				quit
			]
			"Options" [
				"Choose Font..."	choose-font
				"Settings..."		settings
			]
		]
		win/actors: object [
			on-menu: func [face [object!] event [event!]][
				switch event/picked [
					about-msg		[display-about]
					quit			[self/on-close face event]
					choose-font		[
						if font: request-font/font/mono font [
							console/font: font
							terminal/update-cfg font cfg
						]
					]
					settings		[show-cfg-dialog]
				]
			]
			on-close: func [face [object!] event [event!]][
				save-cfg
				clear head system/view/screens/1/pane
			]
			on-resizing: function [face [object!] event [event!]][
				new-sz: event/offset
				console/size: new-sz
				terminal/resize new-sz
				system/console/size: new-sz
				unless system/view/auto-sync? [show face]
			]
		]
		terminal/caret: caret
		terminal/tips: tips
		tips/parent: win
	]

	win: layout/tight [						;-- main window
		title "Red Console"
		size  640x480
	]

	launch: func [/local svs][
		set 'print :terminal/print			;-- custom print

		setup-faces
		win/visible?: no					;-- hide it first to avoid flicker

		view/flags/no-wait win [resize]		;-- create window instance
		console/init
		load-cfg
		win/visible?: yes

		svs: system/view/screens/1
		svs/pane: next svs/pane				;-- proctect itself from unview/all

		system/console/launch
	]
]

red-console-ctx/launch

]