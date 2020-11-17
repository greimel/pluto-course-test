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

# ╔═╡ 3052ed72-28da-11eb-1515-9f5f1a521e7e
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "LaTeXStrings", "Plots"])
	using PlutoUI, LaTeXStrings, Plots
end

# ╔═╡ 8790ae06-28d7-11eb-1b0f-073db2e4b90b
md"""
Choose the number of firms ``N_O``:

$(@bind Nₒ Slider(0:9, default = 6))

Choose the number of firms ``N_N``:

$(@bind Nₙ Slider(0:9, default = 0))
"""

# ╔═╡ ff52a3ee-28d6-11eb-3563-f9d06b9b713a
md"""
# Market Equilibrium

Demand is given by

```math
D(p) = \max \{ 42 - 2p, 0 \}.
```

There are two types of firms (using **old** and **new** technology). Their supply functions are given by

```math
S_O(p) = \begin{cases} p - 1 &\text{if } p \geq 5 \\ 0 &\text{otherwise.} \end{cases}
```

```math
S_N(p) = \begin{cases} p - 3 &\text{if } p \geq 3 \\ 0 &\text{otherwise.} \end{cases}
```

There are $(latexstring("N_O = $Nₒ")) firms with old technology and $(latexstring("N_N = $Nₙ")) firms with new technology.
"""

# ╔═╡ 6db19730-28e5-11eb-0e7e-9d88cc874f89
md"## Appendix"

# ╔═╡ 53da9fae-28d7-11eb-1098-791d5cc30b5d
begin
	D(p) = p <= 21 ? 42 - 2p : 0 # note <if> ? <then> : <else>
	Sₒ(p) = p >= 5 ? p - 1 : 0
	Sₙ(p) = p >= 3 ? p - 3 : 0
	S(p, Nₒ, Nₙ = 0) = Nₒ * Sₒ(p) + Nₙ * Sₙ(p)
end;

# ╔═╡ 46ecf968-28dc-11eb-252a-1fe4e7dca016
p_star(Nₒ, Nₙ) = (42 + Nₒ + 3 * Nₙ) / (2 + Nₒ + Nₙ);

# ╔═╡ 9adb9890-28d7-11eb-2462-e78ad802ff3e
begin
	p1 = LinRange(0,  3.0 - eps(3.0), 20)
	p2 = LinRange(3,  5.0 - eps(5.0), 25)
	p3 = LinRange(5,  25,             100)
	
	p = [p1, p2, p3]
end;

# ╔═╡ aaf3da80-28d7-11eb-2228-6b85433f5355
let
	plot(ylab="price", xlab="quantity")
	
	demand_label_tbd = true
	supply_label_tbd = true
	
	for (i, p_grid) in enumerate(p)
		if true #i < 3
			plot!(D.(p_grid), p_grid, label = "demand"^(demand_label_tbd), color = :green)
			demand_label_tbd = false
		end
		
		supply = S.(p_grid, Nₒ, Nₙ)
		i = findlast(supply .< 42)
		
		if !isnothing(i)
			plot!(S.(p_grid[1:i], Nₒ, Nₙ), p_grid[1:i], label = "supply"^(supply_label_tbd), color = :blue)
			supply_label_tbd = false
		end
	end
	
	pstar = p_star(Nₒ, Nₙ)
	if 5 <= pstar <= 42
		scatter!(D.([pstar]), [pstar], label = "equilibrium", color = :red)
	end
	plot!()
end

# ╔═╡ 61475d48-28dd-11eb-0ae7-392c5a22c031
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
	almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Try it again!", [text]));
	correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));
end

# ╔═╡ b4bbe5b4-28dc-11eb-163f-b12136c1fb37
begin
	pstar = p_star(Nₒ, Nₙ)
	pstar_str = string(round(pstar, digits=3))
	
	if 5 <= pstar <= 42
		correct(md"""Equilibrium found :-) $(latexstring("p^* = $pstar_str"))""")
	else
		keep_working(md""" No equilibrium found. $(latexstring("p^* = $pstar_str"))""")
	end
end

# ╔═╡ Cell order:
# ╟─ff52a3ee-28d6-11eb-3563-f9d06b9b713a
# ╟─8790ae06-28d7-11eb-1b0f-073db2e4b90b
# ╟─aaf3da80-28d7-11eb-2228-6b85433f5355
# ╟─b4bbe5b4-28dc-11eb-163f-b12136c1fb37
# ╟─6db19730-28e5-11eb-0e7e-9d88cc874f89
# ╠═3052ed72-28da-11eb-1515-9f5f1a521e7e
# ╠═53da9fae-28d7-11eb-1098-791d5cc30b5d
# ╠═46ecf968-28dc-11eb-252a-1fe4e7dca016
# ╠═9adb9890-28d7-11eb-2462-e78ad802ff3e
# ╟─61475d48-28dd-11eb-0ae7-392c5a22c031
