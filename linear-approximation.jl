### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ ccde7f0a-1776-11eb-2215-6558131f6482
begin
	using Pkg: Pkg, @pkg_str
	Pkg.activate(mktempdir())
	Pkg.add("GRUtils")
	using GRUtils
end

# ╔═╡ dbac9e1a-1776-11eb-1673-3ba2da7fc0dd
begin
	Pkg.add("ForwardDiff")
	using ForwardDiff: derivative
end

# ╔═╡ b9cc31fa-177b-11eb-37b2-f5c8ed1b56db
md"""**Attention:** This is supplementary material for interested students. The computational material is not relevant for the exam! Prioritize your time wisely! """

# ╔═╡ 3cfcd9dc-1775-11eb-3d10-c9e6c8f22d52
md"""
# Linear approximation

## Exercise 21
"""

# ╔═╡ 56649fcc-1775-11eb-1c08-119514685fc7
md"""
Let us first define $f(x,y,z) = \sqrt{x^2 + y^2 + z^2}$. 
"""

# ╔═╡ af1624a0-1776-11eb-2a51-0501812e4461
f(x, y, z) = √(x^2 + y^2 + z^2) # type √ as \sqrt<TAB>

# ╔═╡ 023fad4a-1777-11eb-1b6a-bb93ba26eecf
md"""
The linear approximation at a point $(x_0, y_0, z_0)$ is given by

$$
L(x, y, z) = f(x_0, y_0, z_0) + f_x(x_0, y_0, z_0)(x-x_0)+{}
$$

$$\qquad\qquad\qquad f_y(x_0, y_0, z_0)(y-y_0) + f_z(x_0, y_0, z_0)(z-z_0)$$

Since we are lazy, we want the computer to compute the linear approximation for us.

(We can use the method of *Automatic Differentiation* which computes exact derivatives up to machine precision. It is implemented in the *Julia* package *ForwardDiff.jl*).
"""

# ╔═╡ 590474c2-177b-11eb-0e72-f55181f27256
md"### 1. Compute partial derivatives"

# ╔═╡ cf6584e8-1777-11eb-3a4d-39cdcb551ef1
x₀, y₀, z₀ = 3, 2, 6

# ╔═╡ 52105214-1779-11eb-0169-912a9b721e22
md"Now compute partial derivatives. For now will do this using partially applied functions. For example, the function $f$, partially applied at $(y_0, z_0)$ is written as `x -> f(x,  y₀, z₀)`. It is now a function of one argument."

# ╔═╡ e65a48c0-177a-11eb-2b4e-8bef1e1da70a
begin
	f_appl_y₀z₀ = x -> f(x,  y₀, z₀)
	f_appl_x₀z₀ = y -> f(x₀, y,  z₀)
	f_appl_x₀y₀ = z -> f(x₀, y₀, z)
end

# ╔═╡ f2b3b3fe-177a-11eb-2753-a9726c9c282e
md"Check how it works. All four expressions give the same results."

# ╔═╡ 02986ba2-177b-11eb-2d78-b78c9ff2ba75
f_appl_y₀z₀(x₀), f_appl_x₀z₀(y₀), f_appl_x₀y₀(z₀), f(x₀, y₀, z₀)

# ╔═╡ 3ac6e9b8-177b-11eb-0f17-79d4b246382f
md"Now we compute partial derivatives using partially applied functions"

# ╔═╡ 41863b26-1778-11eb-2c0e-0f42e623b1da
begin
	f_x = derivative(f_appl_y₀z₀, x₀)
	f_y = derivative(f_appl_x₀z₀, y₀)
	f_z = derivative(f_appl_x₀y₀,  z₀)
	# compute function value at approximation poing
	f₀  = f(x₀, y₀, z₀)
end;

# ╔═╡ 64fcabd2-177b-11eb-2eb3-0b913f8b9463
md"### 2. Compute the linear approximation"

# ╔═╡ 50f22dae-1778-11eb-0924-513c5bced780
L(x, y, z) = f₀ + f_x * (x - x₀) + f_y * (y - y₀) + f_z * (z - z₀) 

# ╔═╡ ed981a80-1778-11eb-2bce-9f449f8132ad
hand = 7 - 6/700

# ╔═╡ 8faccd6a-1778-11eb-1327-8b72d00b9f16
julia = L(3.02, 1.97, 5.99)

# ╔═╡ 9b38a44e-177b-11eb-3a6b-5f74a6dcd708
md"Check if results are identical (up to machine precision)."

# ╔═╡ af627e84-1778-11eb-07f3-65d39279a7e0
julia ≈ hand

# ╔═╡ a79848fc-177b-11eb-00b3-2d25b4fa5a6e
md"Success!"

# ╔═╡ 957bc35a-177c-11eb-071a-b9a57bd99166
md"## Exercise 31: Difference vs differential"

# ╔═╡ 2d78af42-177d-11eb-33cf-5b3141c9d73c
z(x,y) = 5x^2 + y^2

# ╔═╡ 38d6e1d8-177d-11eb-3883-bbc97d030876
begin
	x₁, y₁ = (1, 2)
	x₂, y₂ = (1.05, 2.1)
end

# ╔═╡ 71ccc282-177d-11eb-33b1-9f310ba4ac8c
Δz = z(x₂, y₂) - z(x₁, y₁)

# ╔═╡ 9a7b88f0-177e-11eb-0119-d3fb9e7d912f
begin
	Δx = x₂ - x₁ 
	Δy = y₂ - y₁
end

# ╔═╡ 98d130fc-177d-11eb-3543-cfbf6b6905c3
begin
	∂z∂x = derivative(x -> z(x, y₁), x₁)
	∂z∂y = derivative(y -> z(x₁, y), y₁)
end


# ╔═╡ 864fc8f2-177e-11eb-00af-af8ba4444c85
∂z∂x * Δx + ∂z∂y * Δy

# ╔═╡ e923904e-177e-11eb-08d7-8df18ea504a5
begin
	x_grid = LinRange(0, 2, 50)
	y_grid = LinRange(0, 2, 50)
	z_grid = z.(x_grid, y_grid')
	
	∂_grid = z(x₁, y₁) .+ ∂z∂x .* (x_grid .- x₁) .+ ∂z∂y .* (y_grid' .- x₁)
	surface(x_grid, y_grid, ∂_grid)
	hold(true)
	surface(x_grid, y_grid, ∂_grid)
	#hold(true)
	#surface(x_grid, y_grid, z_grid)
	
	
end

# ╔═╡ fdf13880-1780-11eb-22b5-255c0eef25f9


# ╔═╡ debc5e2c-1776-11eb-20b9-ab19e1caca8f
md"## Appendix"

# ╔═╡ Cell order:
# ╟─b9cc31fa-177b-11eb-37b2-f5c8ed1b56db
# ╟─3cfcd9dc-1775-11eb-3d10-c9e6c8f22d52
# ╟─56649fcc-1775-11eb-1c08-119514685fc7
# ╠═af1624a0-1776-11eb-2a51-0501812e4461
# ╟─023fad4a-1777-11eb-1b6a-bb93ba26eecf
# ╟─590474c2-177b-11eb-0e72-f55181f27256
# ╠═dbac9e1a-1776-11eb-1673-3ba2da7fc0dd
# ╠═cf6584e8-1777-11eb-3a4d-39cdcb551ef1
# ╟─52105214-1779-11eb-0169-912a9b721e22
# ╠═e65a48c0-177a-11eb-2b4e-8bef1e1da70a
# ╟─f2b3b3fe-177a-11eb-2753-a9726c9c282e
# ╠═02986ba2-177b-11eb-2d78-b78c9ff2ba75
# ╟─3ac6e9b8-177b-11eb-0f17-79d4b246382f
# ╠═41863b26-1778-11eb-2c0e-0f42e623b1da
# ╟─64fcabd2-177b-11eb-2eb3-0b913f8b9463
# ╠═50f22dae-1778-11eb-0924-513c5bced780
# ╠═ed981a80-1778-11eb-2bce-9f449f8132ad
# ╠═8faccd6a-1778-11eb-1327-8b72d00b9f16
# ╟─9b38a44e-177b-11eb-3a6b-5f74a6dcd708
# ╠═af627e84-1778-11eb-07f3-65d39279a7e0
# ╟─a79848fc-177b-11eb-00b3-2d25b4fa5a6e
# ╟─957bc35a-177c-11eb-071a-b9a57bd99166
# ╠═2d78af42-177d-11eb-33cf-5b3141c9d73c
# ╠═38d6e1d8-177d-11eb-3883-bbc97d030876
# ╠═71ccc282-177d-11eb-33b1-9f310ba4ac8c
# ╠═9a7b88f0-177e-11eb-0119-d3fb9e7d912f
# ╠═98d130fc-177d-11eb-3543-cfbf6b6905c3
# ╠═864fc8f2-177e-11eb-00af-af8ba4444c85
# ╠═e923904e-177e-11eb-08d7-8df18ea504a5
# ╠═fdf13880-1780-11eb-22b5-255c0eef25f9
# ╟─debc5e2c-1776-11eb-20b9-ab19e1caca8f
# ╠═ccde7f0a-1776-11eb-2215-6558131f6482
