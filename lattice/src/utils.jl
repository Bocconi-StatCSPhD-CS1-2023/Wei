function getRandomPrime(l)
    return Random.rand(primes(2^l, 2^(l+1)))
end