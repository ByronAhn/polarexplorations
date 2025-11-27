import regex
import os

# print(os.getcwd())
output = open("output.tex", "w", encoding='utf8')
input = open("polar-explorations-manuscript-2025-rewrite.tex", "r", encoding='utf8')

for line in input:
    replacedLT = regex.subf(r"(\\langtext)(?<braces>\{((?:[^}{]*(?P>braces)?)*+)\})", "LLLLL({3})", line)
    replacedTL = regex.subf(r"(\\textlabel)(?<braces>\{((?:[^}{]*(?P>braces)?)*+)\})", "TTTTT({3})", replacedLT)
    output.write(replacedTL)


input.close()
output.close()

# [ for line in open('file.txt')]

# # print(regex.findall(r"bf\{(?:[^}{]*(?R)?)*+\}", "some \\\\textbf{I saw the lion \\\\uline{which he loves} in the toy box} when"))
# # print(regex.findall(r"bf(?<braces>\{(?:[^}{]*(?P>braces)?)*+\})", "some \\\\textbf{I saw the lion \\\\uline{which he loves} in the toy box} when"))
# print(regex.subf(r"(\\langtext)(?<braces>\{((?:[^}{]*(?P>braces)?)*+)\})", "#langtext({3})", "some \\langtext{I saw the lion \\uline{which he loves} in the toy box} when"))
# # print(regex.subf(r"(\\langtext\{)((?:[^}{]*(?R)?)*+)(\})", "asdf", "ke in \\langtext{I saw the lion \\uline{which he loves} in the toy box} wi"))
# # print(regex.subf(r"(f)(\w+)( b)(\w+)", "{1}{4}{3}{2}", "foo bar"))