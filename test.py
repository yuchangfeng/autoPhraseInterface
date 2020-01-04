# import sys
# sys.path.append('../')

from runShellFlask.runAutoPhraseHelper import *

## sample usage:
string01 = "She had a lifetime left on this troubled planet, and the man in the pulpit, a baby boomer creeping toward his life expectancy."
string02 = "Was drafting her to save the world after he leaves it."


doc = []
doc.append(string01)
doc.append(string02)

print(generating_list(doc))
