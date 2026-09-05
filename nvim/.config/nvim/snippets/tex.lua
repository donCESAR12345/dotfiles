local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Standard floating figure [htbp]
	s(
		{ trig = "fig", name = "Figure (htbp)", dscr = "Standard floating figure with centering, graphic, caption, label" },
		fmt(
			[[
\begin{figure}[<>]
    \centering
    \includegraphics[width=<>]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "htbp"),
				i(2, "0.85\\linewidth"),
				i(3, "path/to/image"),
				i(4, "Caption text"),
				i(5, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Fixed figure [H] (float package)
	s(
		{ trig = "figh", name = "Figure [H]", dscr = "Fixed figure [H] with centering, graphic, caption, label" },
		fmt(
			[[
\begin{figure}[H]
    \centering
    \includegraphics[width=<>]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "0.85\\linewidth"),
				i(2, "path/to/image"),
				i(3, "Caption text"),
				i(4, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Two subfigures side-by-side
	s(
		{ trig = "subfig", name = "Subfigures (2)", dscr = "Figure with two side-by-side subfigures" },
		fmt(
			[[
\begin{figure}[<>]
    \centering
    \begin{subfigure}{<>}
        \centering
        \includegraphics[width=\linewidth]{<>}
        \caption{<>}
        \label{subfig:<>}
    \end{subfigure}
    \hfill
    \begin{subfigure}{<>}
        \centering
        \includegraphics[width=\linewidth]{<>}
        \caption{<>}
        \label{subfig:<>}
    \end{subfigure}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "H"),
				i(2, "0.48\\linewidth"),
				i(3, "image1"),
				i(4, "Caption 1"),
				i(5, "sub1"),
				i(6, "0.48\\linewidth"),
				i(7, "image2"),
				i(8, "Caption 2"),
				i(9, "sub2"),
				i(10, "Main figure caption"),
				i(11, "main"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Table environment
	s(
		{ trig = "tab", name = "Table", dscr = "Table environment with caption, label, and tabular" },
		fmt(
			[[
\begin{table}[<>]
    \centering
    \caption{<>}
    \label{tab:<>}
    \begin{tabular}{<>}
        \toprule
        <> \\
        \midrule
        <> \\
        \bottomrule
    \end{tabular}
\end{table}
<>
]],
			{
				i(1, "htbp"),
				i(2, "Table caption"),
				i(3, "label"),
				i(4, "cc"),
				i(5, "Header 1 & Header 2"),
				i(6, "Cell 1 & Cell 2"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Numbered equation
	s(
		{ trig = "eq", name = "Equation", dscr = "Numbered equation with label" },
		fmt(
			[[
\begin{equation}
    <>
    \label{eq:<>}
\end{equation}
<>
]],
			{
				i(1, "E = mc^2"),
				i(2, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Align environment
	s(
		{ trig = "al", name = "Align", dscr = "Align multiline math environment" },
		fmt(
			[[
\begin{align}
    <>
\end{align}
<>
]],
			{
				i(1, "x &= y + z"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),
}
