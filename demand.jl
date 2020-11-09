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

# ╔═╡ ae5ee7be-2102-11eb-2517-bf07efcd17c4
begin
	using Pkg
	Pkg.add(["Plots", "PlutoUI"])
	using Plots, PlutoUI
end

# ╔═╡ 2fc7676e-2198-11eb-039f-8bf5ed3f4481
# uncomment below lines if running on binder
begin
	#ENV["PYTHON"]=""
	#Pkg.add("PyCall")
	#Pkg.build("PyCall")
	#Pkg.add("SymPy")
	#using SymPy
end

# ╔═╡ c6e808da-2100-11eb-22e8-1b96706f2fd6
md"# Utility and demand"

# ╔═╡ b6c28632-2101-11eb-2a1b-19d744102a45
md"""
## Question 1

We consider the maximization problem

$$\max_{x_1, x_2 > 0} u(x_1, x_2)$$

subject to the constraint

$$p_1 x_1 + p_2 x_2 \leq m.$$

We consider the following utility functions.
"""

# ╔═╡ f0fb1dc4-2100-11eb-1ff4-15c5b095ef74
begin
	u₁(x₁, x₂) = x₁ * √(x₂)
	u₂(x₁, x₂) = x₁ + x₂ - x₁^2 / 2
	u₃(x₁, x₂) = x₁ + 6x₂
	u₄(x₁, x₂) = min(x₁, 2x₂)
	u₅(x₁, x₂) = min(x₁ + 3x₂, 4x₁ + x₂)
end

# ╔═╡ 59a9646a-2107-11eb-2ce2-ab3390cae267
md"""
* $(@bind is_u1 CheckBox(default=true)) $$u(x_1, x_2) = x_1 \sqrt{x_2}$$
* $(@bind is_u2 CheckBox()) $$u(x_1, x_2) = x_1 + x_2 - \frac{1}{2} x_1^2$$
* $(@bind is_u3 CheckBox()) $$u(x_1, x_2) = x_1 + 6 x_2$$
* $(@bind is_u4 CheckBox()) $$u(x_1, x_2) = \min\{x_1, 2 x_2\}$$
* $(@bind is_u5 CheckBox()) $$u(x_1, x_2) = \min\{x_1 + 3x_2, 4x_1 + x_2\}$$
"""

# ╔═╡ 1d118aee-2109-11eb-2cba-1b4769f96ec9
begin
	selector = [is_u1, is_u2, is_u3, is_u4, is_u5]
	options  = [u₁, u₂, u₃, u₄, u₅]
	msg = md"Selection ok."
	
	i = findfirst(selector)
	if !isnothing(i)
		if sum(selector) > 1
			msg = md"**Warning!** more than one function selected - picked first one"
		end
		u = options[i]
	else
		u = options[1]
	end
	msg
end


# ╔═╡ afba582e-2101-11eb-2ab7-d9d003f49d37
md"""
### (a) Indifference curves

We use a contour plot. First, we chose grids on the domain of $u$.
"""

# ╔═╡ a9777ed2-2102-11eb-1eb5-7193eed7a15b
begin 
	x₁_grid = LinRange(√eps(), 5, 205)
	x₂_grid = LinRange(√eps(), 5, 200)
	u_grid = u.(x₁_grid, x₂_grid')
end;

# ╔═╡ 52261572-210b-11eb-1a6e-f372102c29af
md"Then we determine the level of the level curves through $(1,1)$ and $(2,2)$."

# ╔═╡ 0ec2258c-2106-11eb-1724-21ec64a074dd
begin
	k₁ = u(1, 1)
	k₂ = u(2, 2)
end;

# ╔═╡ 4529e838-2103-11eb-36d1-036bbe732597
begin
	plot(size = (300, 300), dpi = 40, xlab = "x₁", ylab = "x₂")
	# Plot some level curves that are automatically chosen
	contour!(x₁_grid, x₂_grid, u_grid',
		  	 color=:lightgray, colorbar=false)
	# Then plot the level curves trough (1,1) and (2,2)
	contour!(x₁_grid, x₂_grid, u_grid',
		    levels = [k₁, k₂],
		    color=:orange, colorbar=false, contourlabels=true)
	scatter!([1, 2], [1, 2], label = false, color=:orange)
end

# ╔═╡ c56ccf08-210b-11eb-05bf-736d5b0b848f
md"### (b) Marginal rate of substitution (analytical)"

# ╔═╡ bc6411e0-210c-11eb-062a-2d6ebf7d9c96
Base.show(io::IO, ::MIME"text/latex", x::SymPy.SymbolicObject) = print(io, sympy.latex(x, mode="inline"))

# ╔═╡ a4a905ba-210c-11eb-282e-1b16883f280e
@vars x₁ x₂ p₁ p₂ m positive=true

# ╔═╡ 6cf6129c-210f-11eb-3244-65ab27c85105
md"We are currently looking at the following utility function."

# ╔═╡ fbd9a65a-210c-11eb-0a57-4335a3002ba5
u(x₁, x₂)

# ╔═╡ 7c5405be-210f-11eb-0d9b-15450538de34


# ╔═╡ 1f350110-210d-11eb-12f5-0f48067dc473
begin
	MU₁ = diff(u(x₁, x₂), x₁) |> simplify
	MU₂ = diff(u(x₁, x₂), x₂) |> simplify
	MRS_sym = -MU₁ / MU₂ |> simplify
end

# ╔═╡ cc6a5794-210d-11eb-01b4-c5611a880a6a
MRS(a, b) = N(MRS_sym(x₁ => a, x₂ => b))

# ╔═╡ f501f2ae-210e-11eb-157b-7bdd57c7675c
md"""
### (c) Demand functions (analytical)

We need to solve the following conditions.

$$\frac{u_1(x_1, x_2)}{u_2(x_1, x_2)} = \frac{p_1}{p_2}$$
$$p_1 x_1 + p_2 x_2 = m$$
"""

# ╔═╡ 9b47cb32-2111-11eb-3c6f-550f615c564b
FOC = MU₁/MU₂ - p₁/p₂ |> simplify

# ╔═╡ a502c61e-2110-11eb-0b75-fb72a78de73b
BC = p₁ * x₁ + p₂ * x₂ - m

# ╔═╡ 9a9d28d2-210f-11eb-30d3-d71ab2ef444d
demand = solve([FOC, BC], [x₁, x₂])

# ╔═╡ d022fa96-2113-11eb-25a0-15c97e2286a1
demand1 = demand[x₁] |> simplify

# ╔═╡ d8ed1ea4-2113-11eb-3d6d-db4d7786a40c
demand2 = demand[x₂] |> simplify

# ╔═╡ 1bece63a-210f-11eb-2895-4129fa8d5922
md"""
### (d) Is good 1 normal, inferior, ordinary, Giffen?

* normal: consumer more if income $m$ rises
* inferior: consumer less if income $m$ rises
* Giffen good: consume more if price $p_1$ rises

""" 

# ╔═╡ 8850eca0-2113-11eb-3f4e-c34994df0894
dx1dm = diff(demand1, m) |> simplify

# ╔═╡ 52b4f674-2114-11eb-046f-0987e88c0098
if dx1dm > 0
	md"The derivative is positive. That is, the *demand rises if income increases*. Good 1 is a *normal good*."
elseif dx1dm < 0
	md"The derivative is negative. That is, the *demand falls as income increases*. Good 1 is an *inferior good*."
else
	md"**SymPy failed to given an answer.**"
end

# ╔═╡ ef4180dc-2113-11eb-2ea5-0148d7af3159
dx1dp1 = diff(demand1, p₁) |> simplify

# ╔═╡ 1c185558-2115-11eb-01d7-13a209b82037
if dx1dp1 > 0
	md"The derivative is positive. That is, the *demand rises as the price rises*. Good 1 is a *Giffen good*."
elseif dx1dp1 < 0
	md"The derivative is negative. That is, the *demand falls as the price rises*. Good 1 is an *ordinary good*."
else
	md"**SymPy failed to given an answer.**"
end

# ╔═╡ 41bc0f42-2116-11eb-1792-695f97ab59ff
md"""
### (e) Complements or substitutes
"""

# ╔═╡ 9df19f84-2116-11eb-1ab0-096b36e6779c
dx1dp2 = diff(demand1, p₂) |> simplify

# ╔═╡ c180ba7a-2198-11eb-0ee6-6d8937b1b136
if dx1dp2 > 0
	md"The derivative is positive. That is, the *demand for good one rises if price 2 rises*. Goods 1 and 2 are **substitutes**."
elseif dx1dp2 < 0
	md"The derivative is negative. That is, the *demand for good one falls if price 2 rises*. Goods 1 and 2 are **complements**."
elseif dx1dp2 == 0
	md"The derivative is zero. That is, the *demand for good one doesn't react to changes in price 2*. Goods 1 and 2 are **neither complements nor substitutes**."
else
	md"**SymPy failed to given an answer.**"
end

# ╔═╡ Cell order:
# ╠═ae5ee7be-2102-11eb-2517-bf07efcd17c4
# ╠═2fc7676e-2198-11eb-039f-8bf5ed3f4481
# ╟─c6e808da-2100-11eb-22e8-1b96706f2fd6
# ╟─b6c28632-2101-11eb-2a1b-19d744102a45
# ╠═f0fb1dc4-2100-11eb-1ff4-15c5b095ef74
# ╟─59a9646a-2107-11eb-2ce2-ab3390cae267
# ╟─1d118aee-2109-11eb-2cba-1b4769f96ec9
# ╟─afba582e-2101-11eb-2ab7-d9d003f49d37
# ╠═a9777ed2-2102-11eb-1eb5-7193eed7a15b
# ╟─52261572-210b-11eb-1a6e-f372102c29af
# ╠═0ec2258c-2106-11eb-1724-21ec64a074dd
# ╠═4529e838-2103-11eb-36d1-036bbe732597
# ╟─c56ccf08-210b-11eb-05bf-736d5b0b848f
# ╟─bc6411e0-210c-11eb-062a-2d6ebf7d9c96
# ╠═a4a905ba-210c-11eb-282e-1b16883f280e
# ╟─6cf6129c-210f-11eb-3244-65ab27c85105
# ╟─fbd9a65a-210c-11eb-0a57-4335a3002ba5
# ╠═7c5405be-210f-11eb-0d9b-15450538de34
# ╠═1f350110-210d-11eb-12f5-0f48067dc473
# ╠═cc6a5794-210d-11eb-01b4-c5611a880a6a
# ╟─f501f2ae-210e-11eb-157b-7bdd57c7675c
# ╠═9b47cb32-2111-11eb-3c6f-550f615c564b
# ╠═a502c61e-2110-11eb-0b75-fb72a78de73b
# ╠═9a9d28d2-210f-11eb-30d3-d71ab2ef444d
# ╠═d022fa96-2113-11eb-25a0-15c97e2286a1
# ╠═d8ed1ea4-2113-11eb-3d6d-db4d7786a40c
# ╟─1bece63a-210f-11eb-2895-4129fa8d5922
# ╟─8850eca0-2113-11eb-3f4e-c34994df0894
# ╟─52b4f674-2114-11eb-046f-0987e88c0098
# ╟─ef4180dc-2113-11eb-2ea5-0148d7af3159
# ╟─1c185558-2115-11eb-01d7-13a209b82037
# ╟─41bc0f42-2116-11eb-1792-695f97ab59ff
# ╟─9df19f84-2116-11eb-1ab0-096b36e6779c
# ╟─c180ba7a-2198-11eb-0ee6-6d8937b1b136
