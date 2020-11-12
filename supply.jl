### A Pluto.jl notebook ###
# v0.12.7

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
	using Pkg
	Pkg.add("LaTeXStrings")
	using Plots
	using PlutoUI
	using LaTeXStrings
end

# ╔═╡ 99d76cf0-2443-11eb-3dc1-ad81b0458515
md"## Question 2: Plots"

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

# ╔═╡ 95e8ad82-2425-11eb-0a46-dd74424980ee
md"""
Choose output level ``y``: $(@bind y Slider(1:0.5:5, default = 3))

Choose costs ``c``: $(@bind c Slider(1:0.1:40, default = 8))
"""

# ╔═╡ f0e54de2-2424-11eb-3bfc-a72f45982f20
begin
	x₁_max = max(12, c/w₁ + 0.1)
	x₂_max = max(8, budget_line(0, c) + 0.1)
	
	x₁_grid = LinRange(0.0001, x₁_max, 205)
	x₂_grid = LinRange(0.0001, x₂_max, 200)
	y_grid  = f.(x₁_grid, x₂_grid')
end;

# ╔═╡ 553ddf4a-242b-11eb-06c5-396df69dcbda
inputs = intersection_points(c, y);

# ╔═╡ 39e18b92-242e-11eb-1116-e1ee07c05ec6
latexstring("c=$c, \\qquad y = $y")

# ╔═╡ 765fa94e-242b-11eb-2d11-996384eb27cc
if isempty(inputs[1])
md"At these costs we cannot produce $y units of ``y``"
elseif length(inputs[1]) == 1
md"""
At these costs we can produce $y units of ``y`` using the input combinations
	$(round(inputs[1][1], digits=2)), $(round(inputs[2][1], digits=2)).
"""

	
else
md"""
At these costs we can produce $y units of ``y`` using the input combinations
	$(round(inputs[1][1], digits=2)), $(round(inputs[2][1], digits=2))
	or 
	$(round(inputs[1][2], digits=2)), $(round(inputs[2][2], digits=2)).
"""
end

# ╔═╡ f2f34490-2424-11eb-0a0e-e7117f2e6b1d
begin
	contour(x₁_grid, x₂_grid, y_grid', colorbar=false, color=:gray, contour_labels=true, alpha = 0.5, levels=10)
	contour!(x₁_grid, x₂_grid, y_grid', colorbar=false, color=:green, contour_labels=true, levels = [y])
	plot!([0, c/w₁], budget_line.([0, c/w₁], c), color=:red, label="cost $c")
	scatter!(intersection_points(c, y)..., color = :blue, label = "possible inputs")
end


# ╔═╡ Cell order:
# ╠═81f9edca-2424-11eb-0f7f-bba3aa6bf064
# ╠═99d76cf0-2443-11eb-3dc1-ad81b0458515
# ╠═a7333280-2443-11eb-3534-61ac0ae7e361
# ╠═bacd62d6-2443-11eb-215e-b586077a8b74
# ╠═ca0706d8-2443-11eb-0cd1-df17b2a9a885
# ╟─70409890-2424-11eb-0e99-7be360e7fa65
# ╠═ea3b1e52-2426-11eb-3763-83a0e7cab573
# ╠═7b6c8714-2425-11eb-3f4a-f76e38ece10a
# ╟─d3986c7c-2426-11eb-3f89-4530e9f3f29d
# ╟─a6b4eba0-2425-11eb-1d08-0b19806845e5
# ╟─f0e54de2-2424-11eb-3bfc-a72f45982f20
# ╟─553ddf4a-242b-11eb-06c5-396df69dcbda
# ╟─95e8ad82-2425-11eb-0a46-dd74424980ee
# ╟─39e18b92-242e-11eb-1116-e1ee07c05ec6
# ╟─765fa94e-242b-11eb-2d11-996384eb27cc
# ╟─f2f34490-2424-11eb-0a0e-e7117f2e6b1d
