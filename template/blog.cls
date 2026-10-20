\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{blog}[2026/10/20 Blog class]

\LoadClass{article}

\author{PENG}
\date{\today}

\RequirePackage{geometry}
\RequirePackage{amsmath}  % formula
\RequirePackage{amsthm}   % proof
\RequirePackage{amssymb}  % \mathbb{R}
\RequirePackage{graphicx} % \includegraphics
\RequirePackage{biblatex} % \autocite{}
\RequirePackage{hyperref} % \href{http}{text} or \url{http}
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{upquote}  % ` for \verbatim

\geometry{a4paper, left=2.54cm, right=2.54cm, bottom=2.54cm, top=2.54cm}
\graphicspath{{../../images}}
\addbibresource{../../template/library.bib}

\numberwithin{equation}{section}
\numberwithin{figure}{section}
\numberwithin{table}{section}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{assumption}[theorem]{Assumption}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{axiom}[theorem]{Axiom}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{example}[theorem]{Example}
\newtheorem{exercise}[theorem]{Exercise}