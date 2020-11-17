### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 81f9edca-2424-11eb-0f7f-bba3aa6bf064
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "LaTeXStrings", "Plots"])
	using PlutoUI, LaTeXStrings, Plots
end

# ╔═╡ fc203a98-28e6-11eb-0db5-81319d2b62d1
md"""**Attention:** This is supplementary material for interested students. The computational material is not relevant for the exam! Prioritize your time wisely! """

# ╔═╡ 99d76cf0-2443-11eb-3dc1-ad81b0458515
md"""
## Long-run and short-run profits

This is an illustration of Problem 2 on Problem Set 3B.
"""

# ╔═╡ a7333280-2443-11eb-3534-61ac0ae7e361
π_long(p) = p^6/16

# ╔═╡ bacd62d6-2443-11eb-215e-b586077a8b74
π_short(p) = √2 * 4 * p^(3/2) - 12

# ╔═╡ ca0706d8-2443-11eb-0cd1-df17b2a9a885
plot([π_long π_short], 0, 3, label=["long-run" "short-run"], legend = :topleft)

# ╔═╡ 70409890-2424-11eb-0e99-7be360e7fa65
md"""
# Cost minimization with a kink

"""

# ╔═╡ 57f1981a-28e9-11eb-0b8b-459e364aa5a5
md"This is an illustration of Problem 3 on Problem Set 3B."

# ╔═╡ ea3b1e52-2426-11eb-3763-83a0e7cab573
begin
	left(x₁, x₂) = x₁ + x₂
	right(x₁, x₂) = 3x₁
	f(x₁, x₂) = min(left(x₁, x₂), right(x₁, x₂))
end

# ╔═╡ 7b6c8714-2425-11eb-3f4a-f76e38ece10a
w₁, w₂ = 6, 3 

# ╔═╡ a6b4eba0-2425-11eb-1d08-0b19806845e5
budget_line(x₁, c) = (c - w₁ * x₁) / w₂

# ╔═╡ 95e8ad82-2425-11eb-0a46-dd74424980ee
md"""
Choose output level ``y``: $(@bind y Slider(1:0.5:5, default = 3))

Choose costs ``c``: $(@bind c Slider(1:0.1:40, default = 8))
"""

# ╔═╡ 62386aca-28e8-11eb-0094-934deb48984a
md"""

Output is given by $(latexstring("y = $y")) and costs are given by $(latexstring("c = $c")).
"""

# ╔═╡ 150820f2-28e7-11eb-1e1a-9d64526638fd
md"## Appendix"

# ╔═╡ d3986c7c-2426-11eb-3f89-4530e9f3f29d
function intersection_points(c, y)
	x₁₁ = y / 3
	x₁₂ = (c - w₂ * y) / (w₁ - w₂)
	
	if x₁₂ < x₁₁
		x₁ = []
	elseif x₁₂ == x₁₁
		x₁ = [x₁₁]
	else
     	x₁ = [x₁₁, x₁₂]
	end
	
	x₂ = budget_line.(x₁, c)
	if true#length(x₂) > 0
		x₁[x₂ .>= 0], x₂[x₂ .>= 0]
	else
		[], []
	end
end 

# ╔═╡ 553ddf4a-242b-11eb-06c5-396df69dcbda
inputs = intersection_points(c, y);

# ╔═╡ f0e54de2-2424-11eb-3bfc-a72f45982f20
begin
	x₁_max = max(12, c/w₁ + 0.1)
	x₂_max = max(8, budget_line(0, c) + 0.1)
	
	x₁_grid = LinRange(0.0001, x₁_max, 205)
	x₂_grid = LinRange(0.0001, x₂_max, 200)
	y_grid  = f.(x₁_grid, x₂_grid')
end;

# ╔═╡ f2f34490-2424-11eb-0a0e-e7117f2e6b1d
begin
	contour(x₁_grid, x₂_grid, y_grid', colorbar=false, color=:gray, contour_labels=true, alpha = 0.5, levels=10)
	contour!(x₁_grid, x₂_grid, y_grid', colorbar=false, color=:green, contour_labels=true, levels = [y])
	plot!([0, c/w₁], budget_line.([0, c/w₁], c), color=:red, label="cost $c")
	scatter!(intersection_points(c, y)..., color = :blue, label = "possible inputs")
end


# ╔═╡ 5b7db5ba-28e7-11eb-019f-bb31f5511e79
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
	almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Try it again!", [text]));
	correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));
end

# ╔═╡ 765fa94e-242b-11eb-2d11-996384eb27cc
if isempty(inputs[1])
	keep_working(md"At these costs we cannot produce $y units of ``y``")
elseif length(inputs[1]) == 1
	correct(md"""At these costs we can produce $y units of ``y`` using the input combinations
	$(round(inputs[1][1], digits=2)), $(round(inputs[2][1], digits=2)).""")

	else
	correct(md"""
At these costs we can produce $y units of ``y`` using the input combinations
	$(round(inputs[1][1], digits=2)), $(round(inputs[2][1], digits=2))
	or 
	$(round(inputs[1][2], digits=2)), $(round(inputs[2][2], digits=2))""")
end

# ╔═╡ Cell order:
# ╟─fc203a98-28e6-11eb-0db5-81319d2b62d1
# ╟─99d76cf0-2443-11eb-3dc1-ad81b0458515
# ╠═a7333280-2443-11eb-3534-61ac0ae7e361
# ╠═bacd62d6-2443-11eb-215e-b586077a8b74
# ╠═ca0706d8-2443-11eb-0cd1-df17b2a9a885
# ╟─70409890-2424-11eb-0e99-7be360e7fa65
# ╟─57f1981a-28e9-11eb-0b8b-459e364aa5a5
# ╠═ea3b1e52-2426-11eb-3763-83a0e7cab573
# ╠═7b6c8714-2425-11eb-3f4a-f76e38ece10a
# ╟─a6b4eba0-2425-11eb-1d08-0b19806845e5
# ╟─62386aca-28e8-11eb-0094-934deb48984a
# ╟─95e8ad82-2425-11eb-0a46-dd74424980ee
# ╟─f2f34490-2424-11eb-0a0e-e7117f2e6b1d
# ╟─765fa94e-242b-11eb-2d11-996384eb27cc
# ╟─150820f2-28e7-11eb-1e1a-9d64526638fd
# ╠═81f9edca-2424-11eb-0f7f-bba3aa6bf064
# ╠═d3986c7c-2426-11eb-3f89-4530e9f3f29d
# ╠═553ddf4a-242b-11eb-06c5-396df69dcbda
# ╠═f0e54de2-2424-11eb-3bfc-a72f45982f20
# ╠═5b7db5ba-28e7-11eb-019f-bb31f5511e79
