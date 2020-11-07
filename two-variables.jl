### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 9dc3d954-16b3-11eb-2402-c7f683027456
begin
	using Pkg: Pkg, @pkg_str
	Pkg.activate(mktempdir())
end

# ╔═╡ 46a5864c-16b4-11eb-1d48-573c37b7ff2f
begin
	Pkg.add("GRUtils")
	using GRUtils
end

# ╔═╡ 1819c7d4-16a2-11eb-3299-25b54063cb40
md" # Visualizing functions of two variables "

# ╔═╡ 864da4cc-16a3-11eb-088c-511eff470d07
md"""
We visualize the follwing functions.

 * $ f_5(x, y) = 6 - 3x - 2y $
 * $ f_6(x, y) = \sqrt{9 - x^2 - y^2} $
 * $ f_7(x, y) = 1.01 y^{0.75} x^{0.25} $
 * $ f_8(x, y) = 4x^2 + y^2 + 1 $
 * $ f_{19}(x, y) = - x y \exp(-x^2 - y^2) $

First, define the function $f$.
"""

# ╔═╡ 2c263246-16a2-11eb-23b2-7f4fd8e1b6b5
begin
	f_5(x, y) = 6 - 3x - 2y
    f_6(x, y) = sqrt(9 - x^2 - y^2)
 	f_7(x, y) = 1.01 * y^0.75 * x^0.25
 	f_8(x, y) = 4x^2 + y^2 + 1
	f_19(x, y) = - x * y * exp(-x^2 - y^2)
end;

# ╔═╡ 0544e708-16aa-11eb-208d-ddadf3952bd5
f = f_19

# ╔═╡ 90ebbe5a-16a3-11eb-1c4b-65113bc2f7bc
md"Then define the domain of $f$."

# ╔═╡ 4391add2-16a2-11eb-049b-171e8579e593
begin 
	x_grid = LinRange(-2, 2, 100)
	y_grid = LinRange(-2, 2, 100)
end;

# ╔═╡ 3c823c6e-16af-11eb-0dd6-3307ca07bc9d
md"Compute $z = f(x, y)$."

# ╔═╡ 49a9de9e-16af-11eb-1bf1-239cd781456c
z_grid = f.(x_grid, y_grid');

# ╔═╡ 11c0a93c-16a4-11eb-2027-7173335a78f5
md"Now, we can visualize the function."

# ╔═╡ a7ec1b32-16af-11eb-3699-5d1c69e9772d
md"Plotting some **level curves of $f$** using a `contour` plot."

# ╔═╡ 669ac930-16a2-11eb-3a31-e359714b12dc
contour(x_grid, y_grid, z_grid,
	    #color = :black,
	    colorbar=false,
	    #contour_labels=true,
        xlabel = "x", ylabel = "y"
)

# ╔═╡ bd9c9be8-16af-11eb-158e-0bb80919323b
md"Plotting the **graph of $f$** using a `surface` plot."

# ╔═╡ 885a63a0-16a2-11eb-15f9-53268ce97c36
surface(x_grid, y_grid, z_grid,
        xlabel = "x", ylabel = "y", zlabel = "z")

# ╔═╡ dd76fbc4-16b0-11eb-3f71-755bfceafd62
md"Plotting a `heatmap` of $f$."

# ╔═╡ 51c5db4e-1771-11eb-3b4b-d7e7c72b9c26
contourf(x_grid, y_grid, z_grid,
         xlabel = "x", ylabel = "y") #filled contour

# ╔═╡ aa06b93a-16b2-11eb-1574-8f97db9eeb12
md"""This notebook was used in tutorial 1A of *Microeconomics for AE* at the University of Amsterdam in Fall 2020.

This notebook was written for the current development version of *Julia* (1.6-dev Oct 25).

**Attention:** If you want to run this notebook on the current stable version (*Julia* 1.5) you might have to remove the `surface` plot.


(c) 2020 Fabian Greimel
"""

# ╔═╡ 7aa75dc2-1773-11eb-0a0f-6ddfeb6ae12c
function center2cell(grid)
	halfΔgrid = diff(grid)[[1;1:end]] ./2
	cell_boundaries = grid .- halfΔgrid
	push!(cell_boundaries, grid[end] + halfΔgrid[end])
	cell_boundaries
end

# ╔═╡ 7b0d2356-16af-11eb-26f4-3720209602e0
heatmap(center2cell(x_grid), center2cell(y_grid), z_grid,
    	xlabel = "x", ylabel = "y"
)


# ╔═╡ Cell order:
# ╟─1819c7d4-16a2-11eb-3299-25b54063cb40
# ╟─864da4cc-16a3-11eb-088c-511eff470d07
# ╠═2c263246-16a2-11eb-23b2-7f4fd8e1b6b5
# ╠═0544e708-16aa-11eb-208d-ddadf3952bd5
# ╟─90ebbe5a-16a3-11eb-1c4b-65113bc2f7bc
# ╠═4391add2-16a2-11eb-049b-171e8579e593
# ╟─3c823c6e-16af-11eb-0dd6-3307ca07bc9d
# ╠═49a9de9e-16af-11eb-1bf1-239cd781456c
# ╟─11c0a93c-16a4-11eb-2027-7173335a78f5
# ╟─a7ec1b32-16af-11eb-3699-5d1c69e9772d
# ╠═669ac930-16a2-11eb-3a31-e359714b12dc
# ╟─bd9c9be8-16af-11eb-158e-0bb80919323b
# ╠═885a63a0-16a2-11eb-15f9-53268ce97c36
# ╟─dd76fbc4-16b0-11eb-3f71-755bfceafd62
# ╟─7b0d2356-16af-11eb-26f4-3720209602e0
# ╟─51c5db4e-1771-11eb-3b4b-d7e7c72b9c26
# ╟─aa06b93a-16b2-11eb-1574-8f97db9eeb12
# ╟─9dc3d954-16b3-11eb-2402-c7f683027456
# ╠═46a5864c-16b4-11eb-1d48-573c37b7ff2f
# ╠═7aa75dc2-1773-11eb-0a0f-6ddfeb6ae12c
