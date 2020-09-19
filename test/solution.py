if __name__ == "__main__":
    fptr = open(os.environ['OUTPUT_PATH'], 'w')
    n = int(input().strip())

    result = 2 * n

    fptr.write(str(result) + '\n')
    fptr.close()
