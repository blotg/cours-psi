\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{autre}[2020/10/13 autre]

%% Fallback
\DeclareOption*{
  \ClassWarning{autre}{Unknown option '\CurrentOption'}
}

%% Execute default options
\PassOptionsToClass{11pt}{article}

%% Process given options
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{prepa}

\geometry{paper=a3paper,landscape,left=1cm,right=1cm,top=1cm,bottom=1cm}

\pagestyle{empty}

\endinput
