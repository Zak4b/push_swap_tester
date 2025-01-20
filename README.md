# Push Swap Tester

**Push Swap Tester** is a Bash script designed to test the reliability, performance, and memory management of the **Push Swap** program. It includes validity checks, performance benchmarking, and memory leak detection using `valgrind`.

## 🎯 Purpose

This script evaluates:

1. **Result Validity**: Verifies if the `push_swap` program produces correct solutions for various sets of random numbers.
2. **Performance**: Measures the number of moves generated by `push_swap` to solve permutations.
3. **Memory Management**: Detects memory leaks or other issues using `valgrind`.

---

## 🚀 Usage

### Prerequisites

-   `bash`
-   `valgrind`
-   `curl` (for automatic downloading of the `checker` file, if needed)

### Running the Script

Run with curl:

```bash
curl -sSL https://raw.githubusercontent.com/Zak4b/push_swap_tester/refs/heads/main/push_swap_tester.sh | bash
```

or clone the repo:

```bash
git clone https://github.com/Zak4b/push_swap_tester.git
cd push_swap_tester
./push_swap_tester.sh PUSH_SWAP
```

-   **PUSH_SWAP**: Path to your `push_swap` executable (default: `./push_swap`).

---

## 🛠️ Features

### Included Tests

1. **Memory Tests (`push_swap_memtest`)**

    - Verifies that your program:
        - Has no memory leaks.
        - Properly handles invalid inputs, duplicate arguments, etc.

2. **No Output Test (`push_swap_nooutput`)**

    - Ensures that `push_swap` produces no output when no actions are required.

3. **Correctness Tests (`push_swap_test`)**

    - Tests various input cases to ensure the solution is valid when validated with the `checker` program.

4. **Performance Benchmarking (`push_swap_bench`)**
    - Measures the number of moves generated by `push_swap` for solving lists of size 5, 100, or 500.
    - Outputs the minimum, average, and maximum number of moves during the benchmark.

---

## 📋 Example Output

```plaintext
Push Swap tester
Memory test
OK KO OK
==14952== Memcheck, a memory error detector
==14952== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==14952== Using Valgrind-3.19.0 and LibVEX; rerun with -h for copyright info
==14952== Command: ./push_swap ''
==14952==
==14952==
==14952== HEAP SUMMARY:
==14952==     in use at exit: 1 bytes in 1 blocks
==14952==   total heap usage: 2 allocs, 1 frees, 1 bytes allocated
==14952==
==14952== LEAK SUMMARY:
==14952==    definitely lost: 0 bytes in 0 blocks
==14952==    indirectly lost: 0 bytes in 0 blocks
==14952==      possibly lost: 0 bytes in 0 blocks
==14952==    still reachable: 1 bytes in 1 blocks
==14952==         suppressed: 0 bytes in 0 blocks
==14952== Reachable blocks (those to which a pointer was found) are not shown.
==14952== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==14952==
==14952== For lists of detected and suppressed errors, rerun with: -s
==14952== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
Testing 5 values
OK OK OK KO OK OK OK OK OK
KO with "2 1 3 4 5"
Testing 100 values
OK OK OK OK OK OK OK OK OK
Testing 500 values
OK OK OK OK OK OK OK OK OK
Performance on 5 values
Minimum: 5
Average: 7
Maximum: 10
Performance on 100 values
Minimum: 587
Average: 628
Maximum: 666
Performance on 500 values
Minimum: 5004
Average: 5199
Maximum: 5376
```
