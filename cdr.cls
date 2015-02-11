% -*- latex -*-
%
% Document class for Conceptual Design Report

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cdr}[2015/02/02]
\LoadClass[12pt,letterpaper]{report}

\RequirePackage[letterpaper]{geometry}

% Required values and their setters
\newcommand\thevolumetitle{Conceptual Design Report}
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

% Smart end-of-macro spacing
\RequirePackage{xspace}
% Must use units properly and consistently
\RequirePackage[detect-all=true,group-digits=true,group-separator={,},group-minimum-digits=4]{siunitx}

% Long table is long
\RequirePackage{longtable}

% For abbrev/acronym lists
\RequirePackage[intoc]{nomencl}
\makenomenclature  % does this belong here or outside of the class?
\renewcommand{\nomname}{Acronyms, Abbreviations and Units}
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

\newcommand{\rowtitlestyle}{
  \rowcolor{Apricot}
  \rowstyle{\bfseries \boldmath} 
}

\newcommand{\colhline}{
  \arrayrulecolor{red}
  \specialrule{0.5pt}{0pt}{1pt}
  \arrayrulecolor{black}
}

\newcommand{\toprowrule}{
  \arrayrulecolor{red}
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


\newcommand{\cdrtablabel}{}% stores the label
\newcommand{\cdrtabcaption}{}% stores the caption
\newcommand{\cdrtabcaptionshort}{}% stores an optional short caption
\newenvironment{cdrtable}[4][]
{
  \if\relax\detokenize{#1}\relax
  \gdef\cdrtabcaptionshort{\relax}
  \else
  \gdef\cdrtabcaptionshort{#1}
  \fi

  \gdef\cdrtablabel{#3}
  \gdef\cdrtabcaption{#4}

  \begin{table}[hbtp]
    \centering
      \caption[\cdrtabcaptionshort]{\cdrtabcaption}
      \begin{tabular}{#2}
        \toprule
        \rowtitlestyle
}
{
        \bottomrule
      \end{tabular}
      \label{tab:\cdrtablabel}
  \end{table}
}

\newcommand{\cdrfiglabel}{}% stores the label
\newcommand{\cdrfigcaption}{}% stores the caption
\newcommand{\cdrfigcaptionshort}{}% stores an optional short caption
\newenvironment{cdrfigure}[3][]
{
  \if\relax\detokenize{#1}\relax
  \gdef\cdrfigcaptionshort{\relax}
  \else
  \gdef\cdrfigcaptionshort{#1}
  \fi

  \gdef\cdrfiglabel{#2}
  \gdef\cdrfigcaption{#3}

  \begin{figure}[hbtp]
    \centering
}
{
      \caption[\cdrfigcaptionshort]{\cdrfigcaption}
      \label{fig:\cdrfiglabel}
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


