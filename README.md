The project mainly consists of two parts: (1) the implementation of number theoretical transform and two lattice based hash functions (2) a complete implementation according to the standard.







The first part is about lattice based cryptography. We implemented two classic lattice based collision resistant hash functions (implemented in the folder crhf). The first one is based on the short integer solution (SIS) problem (implemented in sis.jl) while the second one is based on ring short integer solution (RingSIS) problem (implemented in ringsis.jl). RingSIS based hash function uses number theoretical transformation, which is a vital tool for general ring lattice based cryptographic primitives. We implemented it in ring.jl and test it in test.jl.


sis.jl: In the file we implement the classic SIS based collision resistant hash function. The formal definition is in https://eprint.iacr.org/2015/939.pdf on page 18, definition 4.1.1. The computation is done in Z_q while the input to the hash function is a vector in Z^m. For the function, one needs a randomly generated matrix in Z_q^{n * m}. To use the function, we first need to set the necessary parameters q, m, n using HashContextSIS(). With the created context, one can use the hash function.

An example to use it is contained in the comment following the codes.

ringsis.jl: In the file we implement the classic RingSIS based collision resistant hash function. The formal definition is in https://eprint.iacr.org/2015/939.pdf on page 27, definition 4.3.1. The computation uses a polynomial ring R=Z[X]/(X^n+1) and a polynomial ring R_q = Z_q[X]/(X^n+1). Note that we represent a ring by the vector of its coefficients. The input to the hash function is a vector of polynomials in R^m. For the function, one needs a randomly generated matrix in R_q^m. To use the function, we first need to set the necessary parameters q, m, n plus the polynomial rings using HashContextRingSIS(). With the created context, one can use the hash function. The hash function heavily rely on multiplication of polynomials, which are done using (1) brute force and (2) NTT.

An example to use it is contained in the comment following the codes.

ring.jl: In the file we implemented computation in ring of polynomials, which is vital for various ring lattice based cryptographic primitives, for example, the above RingSIS based hash function. The main operation to be implemented is polynomial multiplication. As mentioned above, we implemented both the brute force algorithm and NTT based algorithm. The reason we implemented both is that we want a benchmark to verify the correctness of NTT. In order to do NTT, one needs some special ring of polynomials and some precomputed values. All these are done in PolyRing(). Brute force multiplication is done in mult(). NTT and inverse NTT are implemented in NTT() and INTT() according to the formal defintion. The standard NTT based multiplication is implemented in NTT_mult(). But as pointed out in https://eprint.iacr.org/2017/727.pdf on page 3, to use the standard multiplication one needs to pad the inputs. We used the method suggest in the paper to avoid this problem. The code is in NTT_nega(). 

test.jl: In this file we offer some code for testing the implemented NTT based multiplication. We randomly generate two polynomials x and y in R_n, compute their product using (1) brute force multiplication and (2) NTT based multiplcation and then compare the results.

problem: We haven't implemented any optimization for NTT yet. The current implementation is just for understanding how NTT works.





The second part of the project consists of a complete implementation of SHA-3 according to the standard by NIST in https://nvlpubs.nist.gov/nistpubs/fips/nist.fips.202.pdf. We point out that even though Julia has a sha implementation, it is not complete and in particular it does not have the EXTENDABLE-OUTPUT FUNCTIONS defined in section 6.2.

The codes are in the folder sha3:

The hash functions and the extendable output functions are implemented in sha3.jl. The implementation follows the specification in the document. 

The file test.jl contains code for testing the implementation. The test vectors are in the folder test_vectors. They are from NIST as well. See https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/secure-hashing.

See the code and comments in test.jl for how to use and test the functions.





In the file lattice.jl, I exported all the functions. The use is the same as the examples in the file. But to use them, remember to    using .lattice




