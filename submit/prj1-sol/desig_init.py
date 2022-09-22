#!/usr/bin/python
import re
import sys


def motor_code(string_without_white_space, string_reader):
    a_array = []
    count = 0

    try:
        K = len(str(max([int(i) for i in re.findall(r'\d+', string_without_white_space)])))      #this will give count of max digit of number
    except:
        print(string_without_white_space)
        sys.exit(None)
    temp = re.search('\d{% s}'% K, string_without_white_space)
    print (string_without_white_space, "\n")

    for i in string_without_white_space.split(","):
            if ("=" in i):
                    try:
                            index = int(i.split("=")[0].strip("[").strip("]"))
                            val = int(i.split("=")[1])
                    except:
                            variable_a = re.findall(r'\d+', i)
                            variable_b = list(map(int, variable_a))
                            for j in range(0, variable_b[1]-1):
                                    if j in range(variable_b[0]-2, variable_b[1]-1):
                                            a_array.append(variable_b[2])
                                    else:
                                            a_array.append(0)
                            a_array = str(a_array)
                            string_without_white_space = string_without_white_space.replace(i, a_array).replace(" ", "")
                            string_without_white_space = string_without_white_space.replace(" ", "")
                            if "=" in string_without_white_space:
                                modified_motor_code(string_reader)
                                break
                            print( string_without_white_space)
                            sys.exit(None)
                    for j in range(0,index-1):
                            if j != index - 2:
                                    a_array.append(0)
                            else:
                                    a_array.append(val)
                    a_array = str(a_array)
                    string_without_white_space = string_without_white_space.replace(i, a_array).replace(" ", "")
                    print(string_without_white_space)

def dump_output(string_without_white_space, K):
    temp = re.search('\d{% s}'% K, string_without_white_space)
    res = (temp.group(0) if temp else '')
    print (string_without_white_space)
    v = [int(s) for s in string_without_white_space.split() if s.isdigit()]
    print (v)


def modified_motor_code(string_reader):
    string_reader = ''.join(string_reader.splitlines())
    modified_string_reader = string_reader
    new_x = string_reader.replace("{", "[").replace("}", "]").replace(" ", "")
    string_reader = string_reader[string_reader.find('=') + 1:string_reader.rfind('}')]
    string_reader = string_reader[string_reader.find('{') + 1:string_reader.find('}')]
    lst = [a for a in string_reader.split(',')]
    ran = re.findall(r"\[\s*\+?(-?\d+)\s*\]", string_reader)  # gives 3 from [3]=4

    redundant = []
    for i in new_x.split(','):
        if '=' in i:
            redundant.append(i)
    count = 0
    b_array = []
    lst = str(lst).replace(' ', '')
    for i in lst.split(','):
        if '=' in i:
            try:
                index = re.findall(r"\[\s*\+?(-?\d+)\s*\]", i)
                index = int(index[0])
                val = i.strip("'").split('=')[1]
            except:
                abc = re.findall(r'\d+', i)
                xyz = list(map(int, abc))
                for j in range(0, xyz[1] - 1):
                    if j in range(xyz[0] - 2, xyz[1] - 1):
                        b_array.append(xyz[2])
                    else:
                        b_array.append(0)
                b_array = str(b_array)
                lst = lst.replace(i, b_array).replace(' ', '')
                sys.exit(None)
            for j in range(0, index):
                if j != index - 2:
                    b_array.insert(0, 0)
                else:
                    b_array.append(val)
            b_array = str(b_array)
            b_array = b_array.lstrip("[").rstrip("]")
            lst = lst.replace(i, b_array)
            lst = lst.translate({ord("'"): None}) #removes "'" from the number 
        
    yy = modified_string_reader.replace("{", "[").replace("}", "]").replace(" ", "")
    ss = modified_string_reader.strip("{").strip("}")
    k = []
    for i in range(0, 4):
        k.append(0)
    k = str(k).lstrip("[").rstrip("]")
    ss.split(",")
    for i in ss.split(","):
        if ("=" in i):
            break
    ff = re.findall(r'\d+', i)
    ll = list(map(int, ff))
    repeat = ''
    for i in range(ll[0], ll[1]+1):
        repeat = lst + ',' + repeat

    new_s = ss + "," + k + "," + repeat
    new_s = new_s.replace("{", "[").replace("}", "]").replace(" ", "")

    for i in redundant:
        if i in new_s:
            new_s = new_s.replace(i, "")
    new_s = new_s.replace(",,",",").replace(",,",",").replace("77],99,", "") + '99'
    print (new_s, '\n')

def check(my_string):
    brackets = ['()', '{}', '[]']
    while any(x in my_string for x in brackets):
        for br in brackets:
            my_string = my_string.replace(br, '')
            return not my_string


def main():
    string_reader = sys.stdin.read().strip('\n')
    braces_error = {"{":"}", "}":"{", "(":")", "[":"]", "$?":1}
    if string_reader == "$?":
        sys.exit(1)
    try:
        print("expecting {} but got 'EOF'\n" .format(braces_error[string_reader])
            if not check(string_reader) else "")
    except Exception as ex:
        pass
    

    if '.' in string_reader and string_reader.count('.') < 3:
        sys.stderr.write("error: expecting ']' but got '.'\n")
        sys.exit(None)

    if ", ," in string_reader:
        sys.stderr.write("error: expecting '}' but got ','\n")
        sys.exit(None)
        

    string_without_white_space = string_reader.replace("{", "[").replace("}", "]").replace(" ", "")   #replace {,} and removes white space
    try:
        K = len(str(max([int(i) for i in re.findall(r'\d+', string_without_white_space)])))      #this will give count of max digit of number
    except:
        print(string_without_white_space)
        sys.exit(None)
    motor_code(string_without_white_space, string_reader)

if __name__ == "__main__":
    main()
