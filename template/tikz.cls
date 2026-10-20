\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tikz}[2026/10/20 TikZ class]

\LoadClass[tikz]{standalone}

\tikzset{
  basic/.style={font=\fontsize{8}{10}\selectfont,>=latex},
  image/.style={draw=none, inner sep=0pt}
}

\newcommand{\grid}{
  \draw[brown](-4,-4)grid(4,4);
  \foreach \x in {-4,-3.5,...,4} {
      \node at (\x,0) {\tiny \x};
      \node at (0,\x) {\tiny \x};
    }
}