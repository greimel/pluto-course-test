### A Pluto.jl notebook ###
# v0.12.11

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

# ╔═╡ e2aa4dea-2dc5-11eb-0c64-0d4fa9879988
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "LaTeXStrings", "Plots"])
	using PlutoUI, LaTeXStrings, Plots
end

# ╔═╡ 7079c674-2d89-11eb-3038-91ead219646f
md"""
## Market equilibrium with taxes

"""

# ╔═╡ 9bdd9c00-2d89-11eb-18bb-5b8682268ee1
md"""

We assume the linear demand and supply functions.

* Choose the slope of the inverse demand function: $(@bind β_D Slider(0:0.1:10, default=1, show_value=true))
* Choose the slope of the inverse supply function: $(@bind β_S Slider(0:0.1:10, default=1, show_value=true))
* Choose the tax rate $(@bind τ Slider(0.0:0.05:1.0, default=0.2, show_value=true))

"""

# ╔═╡ 2e683936-2dd0-11eb-221b-89f378a8905e
md"""
# Appendix
"""

# ╔═╡ 9f2dae34-2dc7-11eb-36e8-8f9a3f2712c6
md"""
The condition for the equilibrium quantity with a value-added tax is
```math
(\alpha_D - \beta_D q) (1-\tau) = (\alpha_S + \beta_S q)
```
```math
(1-\tau)\alpha_D - \alpha_S = q ((1-\tau)\beta_D + \beta_S)
```
```math
q = 
\frac{
(1-\tau)\alpha_D - \alpha_S
}{
(1-\tau)\beta_D + \beta_S
}
```
"""

# ╔═╡ 6975d312-2dc6-11eb-37e5-89084b97c796
begin
	α_D = 20
	α_S = 5
	P_D(q) = max(α_D - β_D * q, 0)
	P_S(q) = max(α_S + β_S * q, 0)
	q_star(τ=0) = ((1-τ) * α_D - α_S) / (β_S + (1-τ) * β_D)
end

# ╔═╡ d31ea622-2dd0-11eb-08d8-571f7dc51c24
md"""
So, he have the following functional forms:
* inverse demand: $(latexstring("P_D(p) = \\max \\{ 0, $(α_D) - $(β_D) q \\}")),
* inverse supply: $(latexstring("P_S(p) = \\max \\{ 0, $(α_S) + $(β_S) q \\}")).
"""

# ╔═╡ 0ac172f8-2dc7-11eb-20ff-9f734d6a0513
begin
	q0 = q_star()
	p0 = P_D(q0)
	qτ = max(0.0, q_star(τ))
	PDτ = P_D(qτ)
	PSτ = P_S(qτ)
end

# ╔═╡ 5b62e15c-2dcb-11eb-328a-030de304005d
begin
	CSur0 = (α_D - p0) * q0 / 2
	CSurτ = (α_D - PDτ) * qτ / 2
	PSur0 = (p0 - α_S) * q0 / 2
	PSurτ = (PSτ - α_S) * qτ / 2
	
	TR = (PDτ - PSτ) * qτ
	(; CSur0, CSurτ, PSur0, PSurτ, TR)
	
		
end

# ╔═╡ 42a9c634-2dcc-11eb-09b3-f998a2de7cab
begin
	C_reduced = CSurτ / CSur0 - 1
	P_reduced = PSurτ / PSur0 - 1
	
	(; C_reduced, P_reduced)
end

# ╔═╡ a8c08e7c-2dc6-11eb-3144-3963cc575586
q_grid = LinRange(0,α_D / 2, 100)

# ╔═╡ b705d6fe-2dc6-11eb-19b7-c7a60295b5bb
begin
	plot(ylims = [0, 1.1 * α_D])
	plot!(q_grid, P_D.(q_grid), color=:blue, label="Demand")
	plot!(q_grid, P_S.(q_grid), color=:green, label="Supply")
	hline!([p0], label = "prices", color=:red, ls=:dash, alpha=0.5)
	hline!([PDτ], label = "", color=:red, ls=:dash, alpha=1)
	hline!([PSτ], label = "", color=:red, ls=:dash, alpha=1)
	
	vline!([q0], label = "quantity", color=:orange, ls=:dash, alpha=0.5)
	vline!([qτ], label = "", color=:orange, ls=:dash, alpha=1)
	
	# Surpluses
	zero2q = LinRange(0, qτ, 20)
	
	plot!(zero2q, fill(PDτ, 20), ribbon=(zeros(20),P_D.(zero2q) .- fill(PDτ, 20)), lab="consumer surplus $(round(CSurτ, digits=1))", color = :blue)
	plot!(zero2q, fill(PSτ, 20), ribbon=(fill(PSτ, 20) .- P_S.(zero2q), zeros(20)), lab="producer surplus $(round(PSurτ, digits=1))", color = :green)
	plot!(zero2q, fill(PSτ, 20), ribbon=(fill(PSτ - PDτ , 20), zeros(20)), lab="tax revenue $(round(TR, digits=1))", color = :yellow)
	


end
	

# ╔═╡ Cell order:
# ╟─7079c674-2d89-11eb-3038-91ead219646f
# ╟─9bdd9c00-2d89-11eb-18bb-5b8682268ee1
# ╟─d31ea622-2dd0-11eb-08d8-571f7dc51c24
# ╟─b705d6fe-2dc6-11eb-19b7-c7a60295b5bb
# ╟─2e683936-2dd0-11eb-221b-89f378a8905e
# ╠═e2aa4dea-2dc5-11eb-0c64-0d4fa9879988
# ╟─9f2dae34-2dc7-11eb-36e8-8f9a3f2712c6
# ╠═6975d312-2dc6-11eb-37e5-89084b97c796
# ╠═0ac172f8-2dc7-11eb-20ff-9f734d6a0513
# ╠═5b62e15c-2dcb-11eb-328a-030de304005d
# ╠═42a9c634-2dcc-11eb-09b3-f998a2de7cab
# ╠═a8c08e7c-2dc6-11eb-3144-3963cc575586
