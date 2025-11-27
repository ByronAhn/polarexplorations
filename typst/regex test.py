import regex

# output = open("fromOnlineFixed.typ", "w", encoding='utf8')
# input = open("fromOnline.typ", "r", encoding='utf8')

# for line in input:
#     replaced = regex.subf(r"(\\langtext)(?<braces>\{((?:[^}{]*(?P>braces)?)*+)\})", "LLLLL({3})", line)
#     output.write(replaced)

# input.close()
# output.close()

# output = open("fromOnlineFixed.typ", "w", encoding='utf8')
input = open("sample.txt", "r", encoding='utf8').read()

print(regex.findall(r"(?m)caption:\s*\[[^\]]+#label[.\n]+#label", input))
# print(type(input))

# for line in input:
#     replaced = regex.subf(r"(\\langtext)(?<braces>\{((?:[^}{]*(?P>braces)?)*+)\})", "LLLLL({3})", line)
#     output.write(replaced)

# input.close()
# output.close()