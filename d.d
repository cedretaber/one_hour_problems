/**
 * ```
 * $ dmd d.d -main -unittest
 * $ ./d
 * ```
 */

import std.array, std.bigint;

/// 1

int sum_for(int[] list)
{
    int sum;
    for (auto i = 0; i < list.length; ++i) sum += list[i];
    return sum;
}

int sum_while(int[] list)
{
    int sum, i;
    while (i < list.length) {
        sum += list[i];
        ++i;
    }
    return sum;
}

int sum_rec(int[] list)
{
    return list.empty ? 0 : (list[0] + sum_rec(list[1..$]));
}

int sum_tailrec(int[] list, int acc = 0)
{
    return list.empty ? acc : sum_tailrec(list[1..$], acc + list[0]);
}

unittest
{
    int function(int[])[] fs = [ l => sum_for(l), l => sum_while(l), l => sum_rec(l), l => sum_tailrec(l) ];
    foreach (f; fs) {
        assert(15 == f([1,2,3,4,5]));
        assert(0 == f([]));
    }
}

/// 2

E[] zip_list(E)(E[] l1, E[] l2)
{
    size_t i;
    E[] ret;
    while (i < l1.length && i < l2.length) {
        ret = ret ~ l1[i] ~ l2[i];
        ++i;
    }
    return ret;
}

unittest
{
    assert(["a", "1", "b", "2", "c", "3"] == zip_list(["a", "b", "c"], ["1", "2", "3"]));
    assert([1,4,2,5,3,6] == zip_list([1,2,3], [4,5,6]));
    assert([1,6,2,7] == zip_list([1,2,3,4,5], [6,7]));
}

auto make_fib()
{
    BigInt[100] fib;
    fib[0] = BigInt("0");
    fib[1] = BigInt("1");
    foreach (i; 2..100)
        fib[i] = fib[i-1] + fib[i-2];
    
    return fib;
}

unittest
{
    BigInt[100] fib = [BigInt("0"),BigInt("1"),BigInt("1"),BigInt("2"),BigInt("3"),BigInt("5"),BigInt("8"),BigInt("13"),BigInt("21"),BigInt("34"),BigInt("55"),BigInt("89"),BigInt("144"),BigInt("233"),BigInt("377"),BigInt("610"),BigInt("987"),BigInt("1597"),BigInt("2584"),BigInt("4181"),BigInt("6765"),BigInt("10946"),BigInt("17711"),BigInt("28657"),BigInt("46368"),BigInt("75025"),BigInt("121393"),BigInt("196418"),BigInt("317811"),BigInt("514229"),BigInt("832040"),BigInt("1346269"),BigInt("2178309"),BigInt("3524578"),BigInt("5702887"),BigInt("9227465"),BigInt("14930352"),BigInt("24157817"),BigInt("39088169"),BigInt("63245986"),BigInt("102334155"),BigInt("165580141"),BigInt("267914296"),BigInt("433494437"),BigInt("701408733"),BigInt("1134903170"),BigInt("1836311903"),BigInt("2971215073"),BigInt("4807526976"),BigInt("7778742049"),BigInt("12586269025"),BigInt("20365011074"),BigInt("32951280099"),BigInt("53316291173"),BigInt("86267571272"),BigInt("139583862445"),BigInt("225851433717"),BigInt("365435296162"),BigInt("591286729879"),BigInt("956722026041"),BigInt("1548008755920"),BigInt("2504730781961"),BigInt("4052739537881"),BigInt("6557470319842"),BigInt("10610209857723"),BigInt("17167680177565"),BigInt("27777890035288"),BigInt("44945570212853"),BigInt("72723460248141"),BigInt("117669030460994"),BigInt("190392490709135"),BigInt("308061521170129"),BigInt("498454011879264"),BigInt("806515533049393"),BigInt("1304969544928657"),BigInt("2111485077978050"),BigInt("3416454622906707"),BigInt("5527939700884757"),BigInt("8944394323791464"),BigInt("14472334024676221"),BigInt("23416728348467685"),BigInt("37889062373143906"),BigInt("61305790721611591"),BigInt("99194853094755497"),BigInt("160500643816367088"),BigInt("259695496911122585"),BigInt("420196140727489673"),BigInt("679891637638612258"),BigInt("1100087778366101931"),BigInt("1779979416004714189"),BigInt("2880067194370816120"),BigInt("4660046610375530309"),BigInt("7540113804746346429"),BigInt("12200160415121876738"),BigInt("19740274219868223167"),BigInt("31940434634990099905"),BigInt("51680708854858323072"),BigInt("83621143489848422977"),BigInt("135301852344706746049"),BigInt("218922995834555169026")];
    assert(fib == make_fib());
}

long max_num(int[] list)
{
    import std.conv, std.algorithm;
    auto slist = list.to!(string[]);
    sort(slist);
    reverse(slist);
    return slist.join.to!long;
}

unittest
{
    assert(95021 == max_num([50, 2, 1, 9]));
    assert(985148100 == max_num([8, 9, 100, 48, 51]));
}

string[] comb100(int[] nums = [1,2,3,4,5,6,7,8,9], int sum = 100)
{
    import std.conv;

    string[] ret;
    void solve(string[] rest, string res, string buf, int sign, int acm) {
        if (rest.empty) {
            acm += sign * buf.to!int;
            if (acm == sum) ret ~= (res ~ buf);
        } else {
            auto head = rest[0];
            auto tail = rest[1..$];
            auto na = acm + sign * buf.to!int;
            solve(tail, res ~ buf ~ " + ", head, 1, na);
            solve(tail, res ~ buf ~ " - ", head, -1, na);
            solve(tail, res, buf ~ head, sign, acm);
        }
    }
    auto l = nums.to!(string[]);
    solve(l[1..$], "", l[0], 1, 0);

    return ret;
}

unittest
{
    import std.algorithm;
    
    auto expected = ["1 + 2 + 3 - 4 + 5 + 6 + 78 + 9", "1 + 2 + 34 - 5 + 67 - 8 + 9", "1 + 23 - 4 + 5 + 6 + 78 - 9", "1 + 23 - 4 + 56 + 7 + 8 + 9", "12 + 3 + 4 + 5 - 6 - 7 + 89", "12 + 3 - 4 + 5 + 67 + 8 + 9", "12 - 3 - 4 + 5 - 6 + 7 + 89", "123 + 4 - 5 + 67 - 89", "123 + 45 - 67 + 8 - 9", "123 - 4 - 5 - 6 - 7 + 8 - 9", "123 - 45 - 67 + 89"];
    sort(expected);

    auto result = comb100();
    sort(result);

    assert(expected == result);
}