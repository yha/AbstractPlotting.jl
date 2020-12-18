function LRect(fig_or_scene; bbox = nothing, kwargs...)

    topscene = get_topscene(fig_or_scene)

    default_attrs = default_attributes(LRect, topscene).attributes
    theme_attrs = subtheme(topscene, :LRect)
    attrs = merge!(merge!(Attributes(kwargs), theme_attrs), default_attrs)

    @extract attrs (color, visible, valign, halign, padding, strokewidth,
        strokevisible, strokecolor)

    layoutobservables = LayoutObservables{LRect}(attrs.width, attrs.height, attrs.tellwidth, attrs.tellheight,
        halign, valign, attrs.alignmode; suggestedbbox = bbox)

    strokecolor_with_visibility = lift(strokecolor, strokevisible) do col, vis
        vis ? col : RGBAf0(0, 0, 0, 0)
    end

    ibbox = @lift(round_to_IRect2D($(layoutobservables.computedbbox)))

    r = poly!(topscene, ibbox, color = color, visible = visible, raw = true,
        strokecolor = strokecolor_with_visibility, strokewidth = strokewidth)[end]

    elements = Dict(:rect => r)

    # trigger bbox
    layoutobservables.suggestedbbox[] = layoutobservables.suggestedbbox[]

    LRect(fig_or_scene, layoutobservables, attrs, elements)
end