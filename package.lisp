#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:org.shirakumo.alloy
  (:use #:cl)
  (:shadow #:count #:step #:structure #:close #:declaim #:proclaim)
  ;; builder.lisp
  (:export
   #:build
   #:build-ui
   #:define-builder)
  ;; component.lisp
  (:export
   #:component
   #:component-class-for-object
   #:represent-with
   #:represent
   #:ideal-size)
  ;; conditions.lisp
  (:export
   #:alloy-condition
   #:define-alloy-condition
   #:argument-missing
   #:initarg
   #:arg!
   #:index-out-of-range
   #:index
   #:range
   #:hierarchy-error
   #:container
   #:bad-element
   #:element-has-different-parent
   #:element-already-contained
   #:element-not-contained
   #:element-has-different-root
   #:root-already-established
   #:layout-condition
   #:layout
   #:place-already-occupied
   #:place
   #:existing
   #:allocation-failed
   #:renderer)
  ;; components/base.lisp
  (:export
   #:label
   #:wrap
   #:label*
   #:icon
   #:value-component
   #:value-changed
   #:direct-value-component
   #:progress)
  ;; components/button.lisp
  (:export
   #:button
   #:pressed
   #:button*
   #:on-activate)
  ;; components/combo.lisp
  (:export
   #:combo-item
   #:combo
   #:combo-list
   #:combo-item
   #:value-set
   #:combo-set)
  ;; components/drag.lisp
  (:export
   #:draggable
   #:initial-pos
   #:drag-to
   #:resizer
   #:side)
  ;; components/plot.lisp
  (:export
   #:plot
   #:x-range
   #:y-range
   #:plot-points)
  ;; components/radio.lisp
  (:export
   #:radio
   #:active-value
   #:active-p)
  ;; components/switch.lisp
  (:export
   #:switch
   #:off-value
   #:on-value
   #:checkbox
   #:labelled-switch)
  ;; components/text-input.lisp
  (:export
   #:text-input-component
   #:accept
   #:reject
   #:text
   #:insert-mode
   #:cursor
   #:move-to
   #:placeholder
   #:pos
   #:anchor
   #:insert-text
   #:filtered-text-input
   #:accept-character
   #:filter-text
   #:validated-text-input
   #:valid-p
   #:transformed-text-input
   #:previous-value
   #:value->text
   #:text->value
   #:input-line
   #:accept
   #:input-box)
  ;; components/scroll.lisp
  (:export
   #:scrollbar
   #:x-scrollbar
   #:y-scrollbar)
  ;; components/slider.lisp
  (:export
   #:slider
   #:range
   #:step
   #:grid
   #:state
   #:orientation
   #:minimum
   #:maximum
   #:slider-unit
   #:ranged-slider)
  ;; components/symbol.lisp
  (:export
   #:symb
   #:constrained-package
   #:allow-interning)
  ;; components/wheel.lisp
  (:export
   #:wheel
   #:step
   #:grid
   #:ranged-wheel)
  ;; container.lisp
  (:export
   #:element
   #:container
   #:enter
   #:leave
   #:update
   #:elements
   #:element-count
   #:call-with-elements
   #:do-elements
   #:index-element
   #:element-index
   #:clear
   #:vector-container
   #:stack-container
   #:layers
   #:single-container
   #:inner
   #:enter-all)
  ;; data.lisp
  (:export
   #:data
   #:refresh
   #:expand-place-data
   #:expand-compound-place-data
   #:value-data
   #:value
   #:place-data
   #:getter
   #:setter
   #:accessor-data
   #:object
   #:accessor
   #:slot-data
   #:object
   #:slot
   #:aref-data
   #:object
   #:index
   #:computed-data
   #:closure)
  ;; events.lisp
  (:export
   #:handle
   #:event
   #:decline
   #:input-event
   #:pointer-event
   #:location
   #:pointer-move
   #:old-location
   #:pointer-down
   #:kind
   #:pointer-up
   #:kind
   #:scroll
   #:dx
   #:dy
   #:direct-event
   #:copy-event
   #:cut-event
   #:paste-event
   #:content
   #:drop-event
   #:paths
   #:text-event
   #:text
   #:key-event
   #:key
   #:code
   #:modifiers
   #:key-down
   #:key-up
   #:button-event
   #:button
   #:device
   #:button-down
   #:button-up
   #:focus-event
   #:focus-next
   #:focus-prev
   #:focus-up
   #:focus-down
   #:focus-left
   #:focus-right
   #:activate
   #:exit)
  ;; focus-tree.lisp
  (:export
   #:focus-element
   #:set-focus-tree
   #:focus-tree
   #:focus-parent
   #:focus
   #:exit
   #:activate
   #:notice-focus
   #:index
   #:focused
   #:focus-next
   #:focus-prev
   #:focus-up
   #:focus-down
   #:root
   #:focus-element
   #:focus-chain
   #:wrap-focus
   #:focus-list
   #:horizontal-focus-list
   #:vertical-focus-list
   #:focus-grid
   #:focus-stack
   #:focus-tree
   #:popups)
  ;; geometry.lisp
  (:export
   #:x
   #:y
   #:w
   #:h
   #:l
   #:u
   #:r
   #:b
   #:contained-p
   #:pxx
   #:pxy
   #:pxw
   #:pxh
   #:pxl
   #:pxu
   #:pxr
   #:pxb
   #:point
   #:px-point
   #:point-p
   #:point-x
   #:point-y
   #:point=
   #:size
   #:px-size
   #:size-p
   #:size-w
   #:size-h
   #:size=
   #:margins
   #:margins-p
   #:margins-l
   #:margins-u
   #:margins-r
   #:margins-b
   #:margins=
   #:extent
   #:px-extent
   #:extent-p
   #:extent-x
   #:extent-y
   #:extent-w
   #:extent-h
   #:extent=
   #:overlapping-p
   #:ensure-extent
   #:extent-intersection
   #:widen
   #:destructure-extent)
  ;; layout.lisp
  (:export
   #:layout-tree
   #:set-layout-tree
   #:notice-size
   #:suggest-size
   #:preferred-size
   #:ensure-visible
   #:bounds
   #:resize
   #:location
   #:global-location
   #:layout-element
   #:layout-parent
   #:layout
   #:layout-tree
   #:popups)
  ;; layouts/border.lisp
  (:export
   #:border-layout)
  ;; layouts/clip-view.lisp
  (:export
   #:clip-view
   #:clipped-p
   #:offset
   #:stretch)
  ;; layouts/fixed.lisp
  (:export
   #:fixed-layout)
  ;; layouts/flow.lisp
  (:export
   #:flow-layout)
  ;; layouts/grid.lisp
  (:export
   #:grid-layout
   #:row-sizes
   #:col-sizes
   #:stretch
   #:row
   #:col)
  ;; layouts/linear.lisp
  (:export
   #:linear-layout
   #:min-size
   #:stretch
   #:align
   #:cell-margins
   #:vertical-linear-layout
   #:horizontal-linear-layout)
  ;; layouts/popup.lisp
  (:export
   #:popup)
  ;; layouts/swap.lisp
  (:export
   #:swap-layout
   #:index
   #:current)
  ;; layouts/fullscreen.lisp
  (:export
   #:fullscreen-layout)
  ;; observable.lisp
  (:export
   #:observable
   #:observe
   #:remove-observers
   #:list-observers
   #:notify-observers
   #:make-observable
   #:define-observable
   #:on
   #:observable-object)
  ;; renderer.lisp
  (:export
   #:allocate
   #:allocated-p
   #:deallocate
   #:register
   #:render-needed-p
   #:mark-for-render
   #:render
   #:maybe-render
   #:constrain-visibility
   #:reset-visibility
   #:extent-visible-p
   #:translate
   #:renderer
   #:visible-bounds
   #:renderable)
  ;; structure.lisp
  (:export
   #:structure
   #:layout-element
   #:focus-element
   #:finish-structure)
  ;; structures/dialog.lisp
  (:export
   #:dialog
   #:accept
   #:reject
   #:dialog*
   #:message
   #:confirm
   #:with-confirmation)
  ;; structures/menu.lisp
  (:export
   #:separator
   #:menubar
   #:submenu
   #:menu-item
   #:menu
   #:with-menu)
  ;; structures/query.lisp
  (:export
   #:query)
  ;; structures/scroll-view.lisp
  (:export
   #:scroll-view)
  ;; structures/sidebar.lisp
  (:export
   #:sidebar)
  ;; structures/tab-view.lisp
  (:export
   #:tab
   #:name
   #:tab-view
   #:tab-button
   #:index)
  ;; structures/window.lisp
  (:export
   #:window
   #:close
   #:minimize
   #:maximize)
  ;; ui.lisp
  (:export
   #:clipboard
   #:ui
   #:layout-tree
   #:focus-tree
   #:dots-per-cm
   #:target-resolution
   #:resolution-scale
   #:base-scale
   #:smooth-scaling-ui
   #:fixed-scaling-ui
   #:scales
   #:lock-step-scaling-ui
   #:scale-step
   #:scale-direction)
  ;; units.lisp
  (:export
   #:with-unit-parent
   #:unit
   #:unit-value
   #:to-px
   #:to-un
   #:define-unit
   #:px
   #:vw
   #:vh
   #:pw
   #:ph
   #:un
   #:cm
   #:u+
   #:u*
   #:u-
   #:u/
   #:u=
   #:u/=
   #:u<
   #:u>
   #:u<=
   #:u>=)
  ;; widget.lisp
  (:export
   #:widget-class
   #:add-slot
   #:remove-slot
   #:add-initializer
   #:remove-initializer
   #:widget
   #:representation
   #:define-widget
   #:define-subobject
   #:define-subcomponent
   #:define-subcontainer
   #:define-subbutton
   #:remove-subobject
   #:declaim
   #:proclaim))
