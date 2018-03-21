% -*- latex -*-
%
% Document class for DUNE Design Reports

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dune}[2015/02/02]
\LoadClass[12pt,letterpaper]{report}

\RequirePackage[letterpaper,margin=2cm]{geometry}

% Required values and their setters
\newcommand\thedoctitle{DRAFT Technical Design Report}
\newcommand\thedocsubtitle{Deep Underground Neutrino Experiment (DUNE) and Long-Baseline Neutrino Facility (LBNF)}
\def\titleextra{ }

%added because defs.tex asks for it
\newcommand\thevolumetitle{DUNE Documentation Guidance}
\newcommand\thevolumesubtitle{}


% Provide finer-grained sectioning.
\newcounter{subsubsubsection}[subsubsection]
\def\subsubsubsectionmark#1{}
\def\thesubsubsubsection {\thesubsubsection
     .\arabic{subsubsubsection}}
\def\subsubsubsection{\@startsection
     {subsubsubsection}{4}{\z@} {-3.25ex plus -1
     ex minus -.2ex}{1.5ex plus .2ex}{\bf\normalsize\sffamily}}
\def\l@subsubsubsection{\@dottedtocline{4}{4.8em}
     {4.2em}}


% List of other packages required, add as needed.
% Some basic packages
\RequirePackage{color,soul}
\RequirePackage{graphicx}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
% Anne adds parskip 5/7/15
\RequirePackage{parskip}
\setlength{\parskip}{\baselineskip}

% Smart end-of-macro spacing
\RequirePackage{xspace}
% Let's use units properly and consistently!
\RequirePackage[detect-all=true,group-digits=true,group-separator={,},binary-units=true]{siunitx}
% this option trips up some people (eg, tom junk): group-minimum-digits=4,

% Long table is long
\RequirePackage{longtable}

% For abbrev/acronym lists
\RequirePackage[intoc]{nomencl}
\makenomenclature  % does this belong here or outside of the class?
\renewcommand{\nomname}{Acronyms, Abbreviations and Terms}
\setlength{\nomlabelwidth}{0.2\textwidth}

% Tighter control of floats.
\RequirePackage{placeins}


%% fixme: this needs to be controlled by "draft"
\RequirePackage[color]{showkeys}
\RequirePackage[pagewise]{lineno}


\RequirePackage[table,usenames,dvipsnames]{xcolor}

\RequirePackage{framed}
\RequirePackage{wrapfig}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox}

\usetikzlibrary{snakes}
\usetikzlibrary{matrix}
\usetikzlibrary{trees}
\usetikzlibrary{positioning,arrows}
\usetikzlibrary{decorations.pathmorphing}
\usetikzlibrary{decorations.markings}
\usetikzlibrary{shadings}% needed by tcolorbox

% fixme's, must folow xcolor, tikz, ifthen
\RequirePackage{todonotes}
\RequirePackage{menukeys}
\setlength{\marginparwidth}{2cm}

% Fancier headers
\RequirePackage{fancyhdr}

\newcommand{\titlepagecornerblock}{}  
\fancypagestyle{empty}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{titlepage}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyhead[RO]{\titlepagecornerblock}
%  \fancyfoot[C]{\includegraphics[width=0.4\textwidth]{dunelogo_colorhoriz}}
}
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\bfseries \thepage} % except the center
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{simple}{
  \fancyhf{}
  \fancyhead[RO,LE]{\textsf{\footnotesize \thechapter--\thepage}}
  \fancyhead[LO,RE]{\textsf{\footnotesize \leftmark}}
  \fancyfoot[CO,CE]{\textsf{\footnotesize \explong}}
}


% Fancier tables
\RequirePackage{booktabs}
% from http://tex.stackexchange.com/questions/4811/make-first-row-of-table-all-bold:
\newcolumntype{$}{>{\global\let\currentrowstyle\relax}}
%$
\newcolumntype{^}{>{\currentrowstyle}}
\newcommand{\rowstyle}[1]{\gdef\currentrowstyle{#1}%
  #1\ignorespaces
}

\newcolumntype{L}{%
  >{\raggedright
    \bfseries
    \boldmath
  }l}%

%\definecolor{lightblue}{RGB}{212,236,244} ---Anne is changing (212,236,244 is lightblue)
\definecolor{dunetablecolor}{RGB}{125,174,211} % matches lighter blue color from Diana's scheme 
\newcommand{\rowtitlestyle}{
%  \rowcolor{lightblue}
  \rowcolor{dunetablecolor}
  \rowstyle{\bfseries \boldmath} 
}

\newcommand{\colhline}{
  \arrayrulecolor{gray}
  \specialrule{0.5pt}{0pt}{1pt}
  \arrayrulecolor{black}
}

\newcommand{\toprowrule}{
  \arrayrulecolor{gray}
  \specialrule{1.2pt}{0pt}{1pt}
  \arrayrulecolor{black}
}

%%% originals come from booktabs
%%% maybe want to customize:
% \renewcommand{\toprule}{
%   \arrayrulecolor{red}
%   \specialrule{1.5pt}{2pt}{0pt}
%   \arrayrulecolor{black}
% }
% \renewcommand{\midrule}{
%   \arrayrulecolor{red}
%   \specialrule{1pt}{1pt}{1pt}
%   \arrayrulecolor{black}
% }
% \renewcommand{\bottomrule}{
%   \arrayrulecolor{red}
%   \specialrule{1.5pt}{0pt}{2pt}
%   \arrayrulecolor{black}
% }


\newcommand{\dunetablabel}{}% stores the label
\newcommand{\dunetabcaption}{}% stores the caption
\newcommand{\dunetabcaptionshort}{}% stores an optional short caption
\newenvironment{dunetable}[4][]
{
  \if\relax\detokenize{#1}\relax
  \gdef\dunetabcaptionshort{\relax}
  \else
  \gdef\dunetabcaptionshort{#1}
  \fi

  \gdef\dunetablabel{#3}
  \gdef\dunetabcaption{#4}

  \begin{table}[hbtp]
    \centering
      \caption[\dunetabcaptionshort]{\dunetabcaption}
      \begin{tabular}{#2}
        \toprule
        \rowtitlestyle
}
{
        \bottomrule
      \end{tabular}
      \label{\dunetablabel}
  \end{table}
}

\usepackage{tablefootnote}

\newcommand{\dunefiglabel}{}% stores the label
\newcommand{\dunefigcaption}{}% stores the caption
\newcommand{\dunefigcaptionshort}{}% stores an optional short caption
\newenvironment{dunefigure}[3][]
{
  \if\relax\detokenize{#1}\relax
  \gdef\dunefigcaptionshort{\relax}
  \else
  \gdef\dunefigcaptionshort{#1}
  \fi

  \gdef\dunefiglabel{#2}
  \gdef\dunefigcaption{#3}

  \begin{figure}[hbtp]
    \centering
}
{
      \caption[\dunefigcaptionshort]{\dunefigcaption}
      \label{\dunefiglabel}
  \end{figure}
}


%
% Provide an "editors note" environment
% 

\definecolor{editornotecolor}{RGB}{255,255,153}
\newenvironment{editornote}
{
  \begin{center}
    \begin{tcolorbox}[width=0.9\textwidth,
	colframe=editornotecolor!130,
	colback=editornotecolor!20!white,
	skin=enhanced]
}      
{
    \end{tcolorbox}
  \end{center}
}



% Hyperref typically needs to come at the end of all \usepackages 
\RequirePackage[pdftex,bookmarks]{hyperref}

% Use to import pdf files (Anne 4/28/15)
\RequirePackage{pdfpages}

% this seems overly tortured
\newif\iffinal

%\finalfalse
\DeclareOption{final}{
  \finaltrue
}
\ProcessOptions\relax

\iffinal
\presetkeys{todonotes}{disable}{}
\newcommand{\hlfix}[2]{}
\newcommand{\fixme}[1]{}

\else
% "draft"
%Set default style for todonotes
\presetkeys{todonotes}{fancyline}{}
\newcommand{\hlfix}[2]{\texthl{#1}\todo{#2}}
\newcommand{\fixme}[1]{\todo[inline]{#1}}
\linenumbers
\fi

%add TOC, TOF, TOT, Ref to TOC (show up in PDF sidebar for easy navigation)
\RequirePackage{tocbibind}

\usepackage{cprotect}
\usepackage{eurosym}
\usepackage{tfrupee}
\usepackage{textcomp}
