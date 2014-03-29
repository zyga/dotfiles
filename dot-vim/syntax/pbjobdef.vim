" Vim syntax file
" Language:    PlainBox Unit Definition
" Maintainer:  Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
" Last Change: 2014 Mar 04
" URL: 

" Standard syntax initialization
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Should match case except for the keys of each field
syn case match

" Everything that is not explicitly matched by the rules below
syn match pbjobdefElse "^.*$"

" Common separators
syn match pbjobdefComma ", *"
syn match pbjobdefSpace " "

" Define some common expressions we can use later on
syn match pbjobdefPlugin contained "\%(shell\|manual\|local\|resource\|attachment\|user-interact\|user-verify\|user-interact-verify\)"
syn match pbjobdefId contained "[a-z0-9][a-z0-9+./:-]\+"
syn match pbjobdefVariable contained "\${.\{-}}"
syn match pbjobdefSpecialVariable contained "\%(\$PLAINBOX_SESSION_SHARE\|\$PLAINBOX_PROVIDER_DATA\)"
syn match pbjobdefDeprecatedVariable contained "\%(\$CHECKBOX_SHARE\|\$CHECKBOX_DATA\)"
syn match pbjobdefEstimatedDuration contained "\<\d+(\.\d+)?\>"
syn match pbjobdefColonColon contained "::"

" #-Comments
syn match pbjobdefComment "^#.*$" contains=@Spell

syn case ignore

" leading dot in multi-line fields
syn match pbjobdefLeadingDot contained "^\s+\."

" List of all legal keys
syn match pbjobdefKey contained "^\%(id\|plugin\|_?summary\|_?description\|requires\|depends\|estimated_duration\|command\|user\|environ\): *"

syn match pbjobdefDeprecatedKey contained "^\%(name\): *"

" Fields for which we do strict syntax checking
syn region pbjobdefStrictField start="^id" end="$" contains=pbjobdefKey,pbjobdefId,pbjobdefSpace oneline
syn region pbjobdefStrictField start="^plugin" end="$" contains=pbjobdefKey,pbjobdefPlugin,pbjobdefSpace oneline
syn region pbjobdefStrictField start="^estimated_duration" end="$" contains=pbjobdefKey,pbjobdefEstimatedDuration,pbjobdefSpace oneline

" Catch-all for the other legal fields
syn region pbjobdefField start="^\%(id\|plugin\|_?summary\|_?description\|requires\|depends\|estimated_duration\|command\|user\|environ\):" end="$" contains=pbjobdefKey,pbjobdefDeprecatedKey,pbjobdefVariable,pbjobdefColonColon,pbjobdefId oneline
syn region pbjobdefMultiField start="^\%(command\|depends\|requires\):" skip="^ " end="^$"me=s-1 end="^[^ #]"me=s-1 contains=pbjobdefKey,pbjobdefDeprecatedkey,pbjobdefVariable,pbjobdefSpecialVariable,pbjobdefDeprecatedVariable,pbjobdefId,pbjobdefComment,pbjobdefLeadingDot
syn region pbjobdefMultiFieldSpell start="^_?\%(description\|summary\):" skip="^ " end="^$"me=s-1 end="^[^ #]"me=s-1 contains=pbjobdefKey,pbjobdefDeprecatedKey,pbjobdefComment,pbjobdefLeadingDot,@Spell

" Associate our matches and regions with pretty colours
if version >= 508 || !exists("did_pbjobdef_syn_inits")
  if version < 508
    let did_pbjobdef_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pbjobdefPlugin                 Keyword
  HiLink pbjobdefKey                    Keyword
  HiLink pbjobdefField                  Normal
  HiLink pbjobdefStrictField            Error
  HiLink pbjobdefDeprecatedKey          Error
  HiLink pbjobdefDeprecatedVariable     Error
  HiLink pbjobdefEstimatedDuratin       Float
  HiLink pbjobdefMultiField             Normal
  HiLink pbjobdefMultiFieldSpell        Normal
  HiLink pbjobdefId                     Identifier
  HiLink pbjobdefVariable               Identifier
  HiLink pbjobdefSpecialVariable        Identifier
  HiLink pbjobdefComment                Comment
  HiLink pbjobdefElse                   Special
  HiLink pbjobdefLeadingDot             Error
  HiLink pbjobdefColonColon             Keyword

  delcommand HiLink
endif

let b:current_syntax = "pbjobdef"

" vim: ts=4 sw=4
