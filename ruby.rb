# encoding: utf-8

require "test/unit"

# 1

def sum_for list
  # Ruby には for 文は無いので foreach で
  sum = 0
  list.each do |e| sum += e end
  sum
end

def sum_while list
  sum = i = 0
  while i < list.length
    sum += list[i]
    i += 1
  end
  sum
end

def sum_rec list
  return 0 if list.empty?
  list.first + sum_rec(list[1..-1])
end

def sum_tailrec list, acc=0
  if list.empty?
    acc
  else
    sum_tailrec list[1..-1], acc + list.first
  end
end

class Problem1 < Test::Unit::TestCase

  TEST_DATA = { t1: [[1,2,3,4,5], 15], t2: [[], 0] }

  data TEST_DATA
  def test_for data
    i, e = data
    assert_equal e, (sum_for i)
  end

  data TEST_DATA
  def test_while data
    i, e = data
    assert_equal e, (sum_while i)
  end

  data TEST_DATA
  def test_rec data
    i, e = data
    assert_equal e, (sum_rec i)
  end

  data TEST_DATA
  def test_tailrec data
    i, e = data
    assert_equal e, (sum_tailrec i)
  end
end

# 2

def zip_list al, bl
  ret = []
  i = 0
  while i < al.length && i < bl.length
    ret << al[i] << bl[i]
    i += 1
  end
  ret
end

class Problem2 < Test::Unit::TestCase

  data t1: [%w(a b c), [1,2,3], [?a, 1, ?b, 2, ?c, 3]], t2: [[1,2,3,4,5], [6,7,8], [1,6,2,7,3,8]]
  def test_zip_list data
    l1, l2, e = data
    assert_equal e, (zip_list l1, l2)
  end
end

# 3

def make_fib n=100
  fib = [0, 1]
  i = 2
  while i < n # 0..99
    fib << (fib[i-1] + fib[i-2])
    i += 1
  end
  fib
end

class Problem3 < Test::Unit::TestCase

  FIB = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040, 1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, 39088169, 63245986, 102334155, 165580141, 267914296, 433494437, 701408733, 1134903170, 1836311903, 2971215073, 4807526976, 7778742049, 12586269025, 20365011074, 32951280099, 53316291173, 86267571272, 139583862445, 225851433717, 365435296162, 591286729879, 956722026041, 1548008755920, 2504730781961, 4052739537881, 6557470319842, 10610209857723, 17167680177565, 27777890035288, 44945570212853, 72723460248141, 117669030460994, 190392490709135, 308061521170129, 498454011879264, 806515533049393, 1304969544928657, 2111485077978050, 3416454622906707, 5527939700884757, 8944394323791464, 14472334024676221, 23416728348467685, 37889062373143906, 61305790721611591, 99194853094755497, 160500643816367088, 259695496911122585, 420196140727489673, 679891637638612258, 1100087778366101931, 1779979416004714189, 2880067194370816120, 4660046610375530309, 7540113804746346429, 12200160415121876738, 19740274219868223167, 31940434634990099905, 51680708854858323072, 83621143489848422977, 135301852344706746049, 218922995834555169026]

  def test_fib
    assert_equal FIB, make_fib
  end
end

# 4

def max_num list
  list.map(&:to_s).sort.reverse.join.to_i
end

class Problem4 < Test::Unit::TestCase
  data t1: [[50, 2, 1, 9], 95021], t2: [[8, 9, 100, 48, 51], 985148100]
  def test_max_num data
    i, e = data
    assert_equal e, (max_num i)
  end
end

# 5

def comb100 list=[*1..9], sum=100
  list = list.map(&:to_s)

  ret = []
  solve = ->r,a {
    if r.empty?
      ret << a if eval(a) == sum
    else
      h, *t = r
      solve.(t, a + " + " + h)
      solve.(t, a + " - " + h)
      solve.(t, a + h)
    end
  }

  h, *t = list
  solve.(t, h)

  ret
end

class Problem5 < Test::Unit::TestCase
  def test_comb100
    e = ["1 + 2 + 3 - 4 + 5 + 6 + 78 + 9", "1 + 2 + 34 - 5 + 67 - 8 + 9", "1 + 23 - 4 + 5 + 6 + 78 - 9", "1 + 23 - 4 + 56 + 7 + 8 + 9", "12 + 3 + 4 + 5 - 6 - 7 + 89", "12 + 3 - 4 + 5 + 67 + 8 + 9", "12 - 3 - 4 + 5 - 6 + 7 + 89", "123 + 4 - 5 + 67 - 89", "123 + 45 - 67 + 8 - 9", "123 - 4 - 5 - 6 - 7 + 8 - 9", "123 - 45 - 67 + 89"]
    e.sort!

    assert_equal e, comb100.sort
  end
end
