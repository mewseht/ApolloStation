/datum/paint/
	var/icon = 'icons/effects/paint/paint.dmi'
	var/global/list/cached_paint_overlays = list() // Cached icons, so a new icon isn't being generated everytime something changes

	var/icon_modifier = "" // Used for things like object direction, or smoothwall connection
	var/image/paint_icon = null
	var/list/layers = list()

/datum/paint/New( var/modifier = "" )
	icon_modifier = "[modifier]"

	updatePaintIcon()

	..()

/datum/paint/proc/updatePaintIcon()
	var/updated_icon = getCachedPaintIcon()

	if( updated_icon )
		paint_icon = updated_icon
	else
		paint_icon = createPaintIcon()
		cachePaintIcon()

/datum/paint/proc/getCachedPaintIcon()
	var/icon_name = getPaintIconName()
	if( !( icon_name in cached_paint_overlays ))
		return null

	return cached_paint_overlays[icon_name]

/datum/paint/proc/getColor( var/layer = "base" )
	if( !layer || !layers[layer] )
		return

	return paint_colors[getColorName( layer )]

/datum/paint/proc/getColorName( var/layer = "base" )
	if( !layer || !layers[layer] )
		return

	return layers[layer]

/datum/paint/proc/createPaintIcon()
	var/icon/composite = new( icon )

	// Compiling the layers into one image
	for( var/layer in layers )
		// If we had a bad layer, skip it
		if( !layer )
			continue

		var/icon/I = new( icon = icon, icon_state = "[layer][icon_modifier]" )

		// If we had a bad icon, skip it
		if( !I )
			qdel( I )
			continue

		var/color = getColor( layer )

		// If we had a bad color, skip it
		if( !color )
			qdel( I )
			continue

		// Adding the color
		I.Blend( color, ICON_MULTIPLY )

		// Layering it on the composite image
		composite.Blend( I, ICON_OVERLAY )
		qdel( I )

	return image( composite )

/datum/paint/proc/cachePaintIcon()
	cached_paint_overlays[getPaintIconName()] = paint_icon
	return

/datum/paint/proc/clearPaintCache()
	for( var/icon in cached_paint_overlays )
		qdel( icon )

	cached_paint_overlays.Cut()

/datum/paint/proc/getPaintIconName()
	var/icon_name = "_"

	for( var/layer in layers )
		if( !layer )
			continue

		// The first part of the name is
		var/layer_name = "[layer][icon_modifier]_"

		var/color = getColorName( layer )
		if( !color )
			continue

		layer_name += "[color]_"
		icon_name += layer_name

	return icon_name

/datum/paint/proc/paint( var/color, var/layer = "base" )
	if( !color )
		return

	if( color == "remover" )
		unpaint()
		return

	unpaint( layer ) // Remove the old layer so the new one can be on the top

	layers[layer] = color

	updatePaintIcon()

/datum/paint/proc/unpaint( var/layer = null )
	if( !layer )
		layers.Cut()
	else
		layers -= layer

	updatePaintIcon()

/datum/paint/wall
	icon = 'icons/effects/paint/walls.dmi'

/datum/paint/wall/paint( var/color, var/layer = "base", var/connections )
	icon_modifier = "[connections]"

	..()

/datum/paint/wall/red
	layers = list( "base" = "red" )

/datum/paint/wall/orange
	layers = list( "base" = "orange" )

/datum/paint/wall/yellow
	layers = list( "base" = "yellow" )

/datum/paint/wall/green
	layers = list( "base" = "green" )

/datum/paint/wall/blue
	layers = list( "base" = "blue" )

/datum/paint/wall/purple
	layers = list( "base" = "purple" )

/datum/paint/wall/brown
	layers = list( "base" = "brown" )

/datum/paint/wall/black
	layers = list( "base" = "black" )

/datum/paint/wall/phoron
	layers = list( "base" = "phoron" )


/datum/paint/wall/medical
	layers = list( "base" = "white",
				   "stripe0" = "green" )

/datum/paint/wall/engineering
	layers = list( "stripe0" = "orange",
				   "stripe1" = "orange" )

/datum/paint/wall/research
	layers = list( "base" = "white",
				   "stripe0" = "purple",
				   "stripe1" = "purple" )

/datum/paint/wall/cargo
	layers = list( "base" = "orange" )

/datum/paint/wall/security
	layers = list( "base" = "red" )





