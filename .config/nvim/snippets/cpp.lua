local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local function simple_restore(args, _)
  return sn(nil, { i(1, args[1]) })
end


return {
  s("alll", {
    i(1, "x"), t { ".begin(), " },
    d(2, simple_restore, 1), t { ".end()" }
  }),

  s("find_prime", fmt([[
    bool isPrime(int x) {
        for (int i = 2; i <= x / i; i++) {
            if (x % i == 0) {
                return false;
            }
        }
        return true;
    }

    int findPrime(int x) {
        while (!isPrime(x)) {
            x++;
        }
        return x;
    }
  ]], {}, { delimiters = "@$" })),

  s("cfhash", fmt([[
    struct custom_hash {
        static uint64_t splitmix64(uint64_t x) {
            // http://xorshift.di.unimi.it/splitmix64.c
            x += 0x9e3779b97f4a7c15;
            x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
            x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
            return x ^ (x >> 31);
        }

        size_t operator()(uint64_t x) const {
            static const uint64_t FIXED_RANDOM = std::chrono::steady_clock::now().time_since_epoch().count();
            return splitmix64(x + FIXED_RANDOM);
        }
    };
  ]], {}, { delimiters = "@$" })),

  s("tem", fmt([[
    #include <bits/stdc++.h>

    using i64 = long long;

    int main() {
        std::ios::sync_with_stdio(false);
        std::cin.tie(nullptr);

        @$
    }
  ]], { i(1) }, { delimiters = "@$" })),

  s("cf", fmt([[
    #include <bits/stdc++.h>

    using i64 = long long;

    void solve() {
        @$
    }

    int main() {
        std::ios::sync_with_stdio(false);
        std::cin.tie(nullptr);
        int t;
        std::cin >> t;
        while (t--) {
            solve();
        }
    }
  ]], { i(1) }, { delimiters = "@$" })),

  s("bit_ceil", fmt([[
unsigned int bit_ceil(unsigned int n) {
    unsigned int x = 1;
    while (x < (unsigned int)(n)) {
        x *= 2;
    }
    return x;
}
  ]], {}, { delimiters = "@$" })),

  s("z_algorithm", fmt([[
    // one-base
    std::string s = " " + b + "#" + a;
    const int len = s.size();
    std::vector<int> z(len); // max matches
    int l = 0, r = 0;
    z[1] = b.size();
    for (int i = 2; i < len; i++) {
        if (i > r) {
            z[i] = 0;
        } else {
            z[i] = std::min(r - i + 1, z[i - l + 1]);
        }
    ]]
    ..
    "\twhile (i + z[i] < len && s[i + z[i]] == s[1 + z[i]]) {\n"
    ..
    [[
            z[i]++;
        }
        if (i + z[i] - 1 > r) {
            l = i;
            r = i + z[i] - 1;
        }
    }
    ]], {}, { delimiters = "@$" })),

  s("manacher", fmt([[
    auto t = " " + all;
    const int len = t.size() << 1;
    std::string newt;
    newt.resize(len);
    newt[1] = '$';
    for (int i = 1; i < t.size(); i++) {
        newt[i * 2] = t[i];
        newt[i * 2 + 1] = '$';
    }
    std::vector<int> p(len);
    int m = 0, r = 0;
    p[1] = 1;
    for (int i = 1; i < len; i++) {
        if (i > r) {
            p[i] = 1;
        } else {
            p[i] = std::min(r - i + 1, p[m * 2 - i]);
        }
        while (i + p[i] < len && i - p[i] > 0 &&
               newt[ i + p[i] ] == newt[ i - p[i] ]) {
            p[i]++;
        }
        if (i + p[i] - 1 > r) {
            m = i;
            r = i + p[i] - 1;
        }
    }
]], {}, { delimiters = "@#" })),

  s("kmp", fmt([[
std::vector<int> next(const std::string &s) {
    const int N = s.size();
    std::vector<int> next(N + 1);
    for (int i = 1, j = 0; i < N; i++) {
        while (j && s[i] != s[j]) {
            j = next[j];
        }
        if (s[i] == s[j]) {
            j++;
        }
        next[i + 1] = j;
    }

    return next;
}operator

std::vector<int> kmp(const std::string &r, const std::string &s) {
    const int N = r.size(), M = s.size();
    std::vector<int> n = next(s);
    for (int i = 0, j = 0; i < N; i++) {
        while (j && r[i] != s[j]) {
            j = n[j];
        }
        if (r[i] == s[j]) {
            j++;
        }
        n[i + 1] = j;
        if (j == M) {
            j = n[j];
        }
    }
    return n;
}
  ]], {}, { delimiters = "@$" })),

  s("minimal_string", fmt([[
    // zero-base
    std::vector<int> s(n);
    for (int i = 0; i < n; i++) {
        std::cin >> s[i];
    }
    int i = 0, j = 1, k = 0;
    while (i < n && j < n && k < n) {
        if (s[(i + k) % n] != s[(j + k) % n]) {
            if (s[(i + k) % n] > s[(j + k) % n]) {
                i += k + 1;
            } else {
                j += k + 1;
            }
            k = 0;
        } else {
            k++;
        }
        if (i == j) {
            i++;
        }
    }
    i = std::min(i, j);
    ]], {}, { delimiters = "@$" })),

  s("dsu", fmta([[
struct DSU {
    DSU() : n(0) {}
    DSU(int n_) : n(n_), f(n_ + 1), siz(n_ + 1, 1) {
        std::iota(f.begin(), f.end(), 0);
    }

    int n;
    std::vector<int> f, siz;

    int root(int x) { return f[x] == x ? x : f[x] = root(f[x]); }

    int merge(int x, int y) {
        int rx = root(x), ry = root(y);
        if (rx == ry) {
            return rx;
        }
        if (siz[rx] < siz[ry]) {
            std::swap(rx, ry);
            std::swap(x, y);
        }
        siz[rx] += siz[ry];
        f[ry] = rx;
        return rx;
    }
    bool same(int x, int y) { return root(x) == root(y); }
    int size(int x) { return siz[root(x)]; }
};
  ]], {}, { delimiters = "@$" })),

  s("dsu_rollback", fmta([[
struct DSU {
    DSU() : n(0) {}
    DSU(int n_) : n(n_), f(n_ + 1), siz(n_ + 1, 1) {
        std::iota(f.begin(), f.end(), 0);
    }

    int n;
    std::vector<int> f, siz;
    std::vector<std::pair<int &, int>> his;

    int root(int x) {
        while (f[x] != x) {
            x = f[x];
        }
        return x;
    }

    int merge(int x, int y) {
        int rx = root(x), ry = root(y);
        if (rx == ry) {
            return rx;
        }
        if (siz[rx] < siz[ry]) {
            std::swap(rx, ry);
            std::swap(x, y);
        }

        his.push_back({siz[rx], siz[rx]});
        his.push_back({f[ry], ry});

        siz[rx] += siz[ry];
        f[ry] = rx;
        return rx;
    }
    bool same(int x, int y) { return root(x) == root(y); }
    int size(int x) { return siz[root(x)]; }

    void undo(int p) {
        while (p < his.size()) {
            auto &[x, y] = his.back();
            x = y;
            his.pop_back();
        }
    }
}
  ]], {}, { delimiters = "@$" })),

  s("binary_tree", fmta([[
struct BinaryTree {
    struct Node {
        size_t now, l, r;
    };
    size_t size;
    std::vector<Node> node;
    BinaryTree(size_t _size) : size(_size) { node.resize(size + 1); }
    void pre_order(size_t x) {
        std::cout << node[x].now << " ";
        if (valid(node[x].l)) {
            pre_order(node[x].l);
        }
        if (valid(node[x].r)) {
            pre_order(node[x].r);
        }
    }
    void in_order(size_t x) {
        if (valid(node[x].l)) {
            in_order(node[x].l);
        }
        std::cout << node[x].now << " ";
        if (valid(node[x].r)) {
            in_order(node[x].r);
        }
    }
    void post_order(size_t x) {
        if (valid(node[x].l)) {
            post_order(node[x].l);
        }
        if (valid(node[x].r)) {
            post_order(node[x].r);
        }
        std::cout << node[x].now << " ";
    }
    bool valid(size_t x) { return x && x <= size; }
};
  ]], {}, { delimiters = "@$" })),

  s("static_modint", fmt([[
template <i64 _mod>
struct Mint {
public:
    Mint(i64 x) : _x(x % _mod) { norm(x); }
    Mint() : _x(0) {}

    static i64 mod() { return _mod; }

    constexpr i64 val() { return _x; }

    constexpr Mint operator-() { return Mint(-_x); }
    constexpr Mint operator+() { return Mint(_x); }
    constexpr Mint &operator++() {
        norm(_x += 1);
        return *this;
    }
    constexpr Mint operator++(int) {
        Mint pmt = *this;
        ++*this;
        return pmt;
    }
    constexpr Mint &operator--() {
        norm(_x -= 1);
        return *this;
    }
    constexpr Mint operator--(int) {
        Mint pmt = *this;
        --*this;
        return pmt;
    }
    constexpr Mint &operator+=(const Mint &rhs) {
        norm(_x += rhs._x);
        return *this;
    }
    constexpr Mint &operator-=(const Mint &rhs) {
        norm(_x -= rhs._x);
        return *this;
    }
    constexpr Mint &operator*=(const Mint &rhs) {
        norm(_x = _x * rhs._x % _mod);
        return *this;
    }
    constexpr Mint &operator/=(const Mint &rhs) { return *this *= rhs.inv(); }

    friend constexpr Mint operator+(const Mint lhs, const Mint rhs) {
        return Mint(lhs) += rhs;
    }
    friend constexpr Mint operator-(const Mint lhs, const Mint rhs) {
        return Mint(lhs) -= rhs;
    }
    friend constexpr Mint operator*(const Mint lhs, const Mint rhs) {
        return Mint(lhs) *= rhs;
    }
    friend constexpr Mint operator/(const Mint lhs, const Mint rhs) {
        return Mint(lhs) /= rhs;
    }
    friend constexpr bool operator>(const Mint lhs, const Mint rhs) {
        return lhs._x > rhs._x;
    }
    friend constexpr bool operator>=(const Mint lhs, const Mint rhs) {
        return lhs._x >= rhs._x;
    }
    friend constexpr bool operator<(const Mint lhs, const Mint rhs) {
        return lhs._x < rhs._x;
    }
    friend constexpr bool operator<=(const Mint lhs, const Mint rhs) {
        return lhs._x <= rhs._x;
    }
    friend constexpr bool operator==(const Mint lhs, const Mint rhs) {
        return lhs._x == rhs._x;
    }
    friend constexpr bool operator!=(const Mint lhs, const Mint rhs) {
        return lhs._x != rhs._x;
    }

    Mint pow(i64 times) const {
        Mint t(*this);
        Mint ans(1);
        while (times) {
            if (times & 1) {
                ans *= t;
            }
            t *= t;
            times >>= 1;
        }
        return ans;
    }

    Mint inv() const { return this->pow(_mod - 2); }
    friend constexpr std::istream &operator>>(std::istream &is, Mint &mint) {
        is >> mint._x;
        norm(mint._x %= _mod);
        return is;
    }
    friend constexpr std::ostream &operator<<(std::ostream &os,
                                              const Mint &mint) {
        return os << mint._x;
    }

private:
    i64 _x;
    static i64 norm(i64 &x) {
        if (x < 0) {
            x += _mod;
        } else if (x >= _mod) {
            x -= _mod;
        }
        return x;
    }
};

constexpr int mod = @$;
using Z = Mint<mod>;

]], { i(1, "998244353") }, { delimiters = "@$" })),

  s("dynamic_modint", fmt([[
struct Mint {
public:
    Mint(i64 x) : _x(x % _mod) { norm(_x); }
    Mint(i64 x, i64 mod) : _x(x) { _mod = mod, norm(x %= mod); }
    Mint() : _x(0) {}

    static i64 mod() { return _mod; }
    static void setmod(i64 mod) { _mod = mod; }

    i64 val() const { return _x; }

    Mint operator-() const { return Mint(-_x); }
    Mint operator+() const { return Mint(_x); }
    Mint &operator++() {
        norm(_x += 1);
        return *this;
    }
    Mint operator++(int) {
        Mint pmt = *this;
        ++*this;
        return pmt;
    }
    Mint &operator--() {
        norm(_x -= 1);
        return *this;
    }
    Mint operator--(int) {
        Mint pmt = *this;
        --*this;
        return pmt;
    }
    Mint &operator+=(const Mint &rhs) {
        norm(_x += rhs._x);
        return *this;
    }
    Mint &operator-=(const Mint &rhs) {
        norm(_x -= rhs._x);
        return *this;
    }
    Mint &operator*=(const Mint &rhs) {
        norm(_x = _x * rhs._x % _mod);
        return *this;
    }
    Mint &operator/=(const Mint &rhs) { return *this *= rhs.inv(); }

    friend Mint operator+(const Mint lhs, const Mint rhs) {
        return Mint(lhs) += rhs;
    }
    friend Mint operator-(const Mint lhs, const Mint rhs) {
        return Mint(lhs) -= rhs;
    }
    friend Mint operator*(const Mint lhs, const Mint rhs) {
        return Mint(lhs) *= rhs;
    }
    friend Mint operator/(const Mint lhs, const Mint rhs) {
        return Mint(lhs) /= rhs;
    }
    friend bool operator>(const Mint lhs, const Mint rhs) {
        return lhs._x > rhs._x;
    }
    friend bool operator>=(const Mint lhs, const Mint rhs) {
        return lhs._x >= rhs._x;
    }
    friend bool operator<(const Mint lhs, const Mint rhs) {
        return lhs._x < rhs._x;
    }
    friend bool operator<=(const Mint lhs, const Mint rhs) {
        return lhs._x <= rhs._x;
    }
    friend bool operator==(const Mint lhs, const Mint rhs) {
        return lhs._x == rhs._x;
    }
    friend bool operator!=(const Mint lhs, const Mint rhs) {
        return lhs._x != rhs._x;
    }

    Mint pow(i64 times) const {
        Mint t(*this);
        Mint ans(1);
        while (times) {
            if (times & 1) {
                ans *= t;
            }
            t *= t;
            times >>= 1;
        }
        return ans;
    }

    Mint inv() const { return this->pow(mod() - 2); }

    friend std::istream &operator>>(std::istream &is, Mint &mint) {
        is >> mint._x;
        norm(mint._x %= _mod);
        return is;
    }
    friend std::ostream &operator<<(std::ostream &os, const Mint &mint) {
        return os << mint._x;
    }

private:
    static i64 _mod;
    i64 _x;
    static i64 norm(i64 &x) {
        if (x < 0) {
            x += _mod;
        } else if (x >= _mod) {
            x -= _mod;
        }
        return x;
    }
};

using Z = Mint;
i64 Z::_mod;
i64 mod;
]], {}, { delimiters = "@$" })),
  s("matrix", fmt([[
template <class T>
struct Matrix {
    Matrix() : r(0), c(0) {}
    Matrix(int r, int c, std::vector<std::vector<T>> &m)
        : r(r), c(c), m(m) {}

    Matrix(int n) : Matrix(n, n) {}
    Matrix(int r, int c) : r(r), c(c) {
        m = std::vector<std::vector<T>>(r, std::vector<T>(c));
    }
    Matrix(std::vector<std::vector<T>> &m) : m(m) {
        assert(m.size() > 0 && m[0].size() > 0);
        r = m.size();
        c = m[0].size();
    }
    constexpr T at(int i, int j) const { return m[i][j]; }
    constexpr T &get(int i, int j) { return m[i][j]; }
    static constexpr Matrix identity(int n) {
        Matrix ret(n);
        for (int i = 0; i < n; i++) {
            ret.m[i][i] = 1;
        }
        return ret;
    }
    constexpr bool square() { return this->c == this->r; }
    constexpr Matrix pow(i64 n) {
        assert(this->square());
        Matrix ret(identity(this->c));
        Matrix temp(*this);
        while (n) {
            if (n & 1) {
                ret *= temp;
            }
            temp *= temp;
            n >>= 1;
        }
        return ret;
    }

    constexpr Matrix &operator*=(const Matrix &rhs) {
        return *this = *this * rhs;
    }

    friend constexpr Matrix operator*(const Matrix &lhs, const Matrix &rhs) {
        assert(lhs.c == rhs.r);
        Matrix ret(lhs.r, rhs.c);
        for (int i = 0; i < lhs.r; i++) {
            for (int j = 0; j < lhs.c; j++) {
                if (lhs.m[i][j] != 0) {
                    for (int k = 0; k < rhs.c; k++) {
                        if (rhs.m[j][k] != 0) {
                            ret.m[i][k] |= lhs.m[i][j] & rhs.m[j][k];
                        }
                    }
                }
            }
        }
        return ret;
    }

    friend std::ostream &operator<<(std::ostream &os, Matrix &a) {
        for (int i = 0; i < a.r; i++) {
            for (int j = 0; j < a.c; j++) {
                os << a.m[i][j] << " \n"[j == a.c - 1];
            }
        }
        return os;
    }

    std::vector<std::vector<T>> m;
    int r, c;
};
]], {}, { delimiters = "@$" })),

  s("trie", fmt([[
struct Trie {
    constexpr static int NEXT = 'z' - '0' + 2;
    constexpr static int offset = '0';
    struct Node {
        int len;
        std::vector<int> next;
        Node() : len{} {
            next.assign(NEXT, 0);
        }
    };

    std::vector<Node> t;

    Trie() { init(); }

    void init() {
        newNode();
    }

    int newNode() {
        t.emplace_back();
        return t.size() - 1;
    }

    int add(const std::vector<int> &a) {
        int p = 0;
        for (auto x : a) {
            if (t[p].next[x] == 0) {
                t[p].next[x] = newNode();
                t[ t[p].next[x] ].len = t[p].len + 1;
            }


            p = t[p].next[x];
        }

        return p;
    }

    int add(const std::string &a) {
        std::vector<int> b(a.begin(), a.end());
        for (auto &c : b) {
            c -= offset;
        }
        return add(b);
    }

    int query(const std::vector<int> &a) {
        int p = 0;
        for (auto x : a) {
            if (t[p].next[x] == 0) {
                return 0;
            }

            p = t[p].next[x];
        }

        return p;
    }

    int query(const std::string &a) {
        std::vector<int> b(a.begin(), a.end());
        for (auto &c : b) {
            c -= offset;
        }
        return query(b);
    }
};
    ]], {}, { delimiters = "@$" })),

  s("ac_automation", fmt([[
struct AC {
    constexpr static int NEXT = 26;
    constexpr static int offset = 'a';
    struct Node {
        int len;
        int link;
        std::vector<int> next;
        Node() : len{}, link{} { next.assign(NEXT, 0); }
    };

    std::vector<Node> t;
    std::vector<int> q;

    AC() { init(); }

    void init() { newNode(); }

    int newNode() {
        t.emplace_back();
        return t.size() - 1;
    }

    int add(const std::vector<int> &a) {
        int p = 0;
        for (auto x : a) {
            if (t[p].next[x] == 0) {
                t[p].next[x] = newNode();
                t[ t[p].next[x] ].len = t[p].len + 1;
            }

            p = t[p].next[x];
        }

        return p;
    }

    int add(const std::string &a) {
        std::vector<int> b(a.begin(), a.end());
        for (auto &c : b) {
            c -= offset;
        }
        return add(b);
    }

    void build() {
        int h = 0;

        for (int i = 0; i < NEXT; i++) {
            if (t[0].next[i]) {
                q.push_back(t[0].next[i]);
            }
        }

        while (h < q.size()) {
            int x = q[h];
            h++;

            for (int i = 0; i < NEXT; i++) {
                if (t[x].next[i] == 0) {
                    t[x].next[i] = t[t[x].link].next[i];
                } else {
                    t[ t[x].next[i] ].link = t[t[x].link].next[i];
                    q.push_back(t[x].next[i]);
                }
            }
        }
    }

    void update(std::function<void(int, int)> fun) {
        for (int i = q.size() - 1; i >= 1; i--) {
            fun(link(q[i]), q[i]);
        }
    }

    int next(int p, int i) { return t[p].next[i]; }

    int next(int p, char c) { return next(p, c - offset); }

    int link(int p) { return t[p].link; }

    int len(int p) { return t[p].len; }

    int size() { return t.size(); }
};
  ]], {}, { delimiters = "@$" })),

  s("comb", fmt([[
struct Comb {
    Comb() : _n(0), _fac{1}, _inv{0}, _facinv{1} {};
    Comb(int n) : Comb() {
        init(n);
    }

    Z fac(int n) {
        if (n > _n) {
            init(n);
        }
        return _fac[n];
    }
    Z inv(int n) {
        if (n > _n) {
            init(n);
        }
        return _inv[n];
    }
    Z facinv(int n) {
        if (n > _n) {
            init(n);
        }
        return _facinv[n];
    }

    void init(int n) {
        if (n < _n) {
            return;
        }
        n = std::min(n, static_cast<int>(Z::mod() - 1));
        _fac.resize(n + 1);
        _inv.resize(n + 1);
        _facinv.resize(n + 1);
        for (int i = _n + 1; i <= n; i++) {
            _fac[i] = _fac[i - 1] * i;
        }
        _facinv[n] = _fac[n].inv();
        for (int i = n; i > _n; i--) {
            _facinv[i - 1] = _facinv[i] * i;
            _inv[i] = _facinv[i] * _fac[i - 1];
        }
        _n = n;
    }
    Z binom(int n, int k) {
        if (n < k || k < 0) {
            return 0;
        }
        init(n);
        return _fac[n] * _facinv[k] * _facinv[n - k];
    }

private:
    int _n;
    std::vector<Z> _fac;
    std::vector<Z> _inv;
    std::vector<Z> _facinv;
} comb;
  ]], {}, { delimiters = "@$" })),

  s("rw", fmt([[
std::istream &operator>>(std::istream &is, __int128 &x) {
    x = 0;
    char sign = 1;
    std::string s;
    is >> s;
    for (auto ch : s) {
        if (ch == '-') {
            sign = -1;
        }
        x = x * 10 + ch - '0';
    }
    x *= sign;
    return is;
}

std::ostream &operator<<(std::ostream &os, __int128 x) {
    if (x < 0) {
        os << "-";
        x = -x;
    }
    std::string s;
    do {
        s.push_back('0' + x % 10);
        x /= 10;
    } while (x);

    std::reverse(s.begin(), s.end());
    os << s;

    return os;
}
  ]], {}, { delimiters = "@$" })),

  s("lca", fmt([[
struct Vert {
    int id;
    int max = -1E9;
    int semax = -1E9;
    friend Vert operator+(Vert &lo, Vert &hi) {
        std::set S{lo.max, lo.semax, hi.max, hi.semax};
        auto next = std::next(S.rbegin());
        return {hi.id, *S.rbegin(),
                next == S.rend() || *next == -1E9 ? *S.rbegin() : *next};
    }
};
struct Edge {
    int y;
    int w;
};

struct LCA {
    std::vector<std::vector<Vert>> f;
    std::vector<std::vector<Edge>> adj;
    std::vector<int> d;
    int n;
    int U;
    std::vector<Vert> p;
    // in case size = 1
    LCA(std::vector<Vert> &&p_)
        : p(std::move(p_)),
          adj(p_.size()),
          d(p_.size()),
          n(p_.size()),
          U(std::__lg(p_.size()) + 1) {
        f.assign(p.size(), std::vector<Vert>(U + 1));
    }
    void addEdge(int x, Edge &&e) { adj[x].push_back(e); }
    Vert up(int x, int k) {
        Vert s{p[x]};
        for (int i = 0; k; k /= 2, i++) {
            if (k & 1) {
                s = s + f[s.id][i];
            }
        }
        return s;
    }

    Vert init(Vert &lo, Vert &hi, Edge &e) { return {hi.id, e.w, e.w}; }

    void dfs(int x) {
        for (auto &e : adj[x]) {
            auto y = e.y;
            if (!d[y]) {
                f[y][0] = init(p[y], p[x], e);
                d[y] = d[x] + 1;
                dfs(y);
            }
        }
    }
    void build(int root) {
        d[root] = 1;
        dfs(root);
        for (int i = 1; i <= U; i++) {
            for (int j = 0; j < n; j++) {
                f[j][i] = f[j][i - 1] + f[f[j][i - 1].id][i - 1];
            }
        }
    }
    Vert operator()(int x_, int y_) {
        if (d[x_] < d[y_]) {
            std::swap(x_, y_);
        }
        int diff = d[x_] - d[y_];
        Vert x = up(x_, diff), y = p[y_];
        if (x.id == y.id) {
            return x;
        }
        for (int i = U; i >= 0; i--) {
            Vert X = f[x.id][i];
            Vert Y = f[y.id][i];
            if (X.id != Y.id) {
                x = x + X;
                y = y + Y;
            }
        }

        auto a = x + f[x.id][0];
        auto b = y + f[y.id][0];
        return a + b;
    }
};
]], {}, { delimiters = "@#" })),

  s("hld", fmt([[
struct HLD {
    int n, root;
    std::vector<int> siz, top, dep, p, in, out, seq;
    std::vector<std::vector<int>> adj;
    int idx;

    HLD() {}
    HLD(int n) { init(n); }

    void init(int n, int root = 0) {
        this->n = n;
        this->root = root;
        siz.resize(n, 1);
        top.resize(n);
        dep.resize(n);
        p.resize(n);
        in.resize(n);
        out.resize(n);
        seq.resize(n);
        idx = 0;
        adj.resize(n);
    }

    void addEdge(int x, int y) {
        adj[x].push_back(y);
        adj[y].push_back(x);
    }

    void work() { work(root); }

    void work(int root) {
        top[root] = root;
        p[root] = -1;
        dfs1(root);
        dfs2(root);
    }

    void dfs1(int x) {
        if (p[x] != -1) {
            adj[x].erase(std::find(adj[x].begin(), adj[x].end(), p[x]));
        }
        for (auto &y : adj[x]) {
            p[y] = x;
            dep[y] = dep[x] + 1;
            dfs1(y);
            siz[x] += siz[y];
            if (siz[y] > siz[ adj[x][0] ]) {
                std::swap(y, adj[x][0]);
            }
        }
    }
    void dfs2(int x) {
        seq[idx] = x;
        in[x] = idx++;
        for (auto y : adj[x]) {
            top[y] = adj[x][0] == y ? top[x] : y;
            dfs2(y);
        }
        out[x] = idx;
    }

    int lca(int x, int y) {
        if (isAncestor(x, y)) {
            return x;
        }
        while (top[x] != top[y]) {
            if (dep[ top[x] ] > dep[ top[y] ]) {
                x = p[ top[x] ];
            } else {
                y = p[ top[y] ];
            }
        }

        return dep[x] < dep[y] ? x : y;
    }

    int dist(int x, int y) { return dep[x] + dep[y] - 2 * dep[lca(x, y)]; }

    int jump(int x, int k) {
        if (dep[x] < k) {
            return -1;
        }

        int d = dep[x] - k;
        while (dep[x] < d) {
            x = p[ top[x] ];
        }

        return seq[in[x] - dep[x] + d];
    }

    bool isAncestor(int x, int y) { return in[x] <= in[y] && in[x] < out[y]; }

    int parent(int x) { return parent(x, root); }

    int size(int x) { return size(x, root); }

    int parent(int x, int root) {
        if (x == root) {
            return x;
        }

        if (!isAncestor(x, root)) {
            return p[x];
        }

        auto it =
            std::upper_bound(adj[x].begin(), adj[x].end(), root,
                             [&](int a, int b) { return in[a] < in[b]; }) -
            1;

        return *it;
    }

    int size(int x, int root) {
        if (x == root) {
            return n;
        }
        if (!isAncestor(x, root)) {
            return siz[x];
        }

        return n - siz[parent(x, root)];
    }
};
  ]], {}, { delimiters = "@$" })),

  s("fenwick", fmt([[
template <class T>
struct Fenwick {
    Fenwick(int n_ = 0) : n(n_), info(n_ + 2, T()) {}
    Fenwick(int n_, std::vector<T> a) : n(n_), info(n_ + 2, T()) {
        for (int i = 1; i <= n; i++) {
            info[i] += a[i];
            auto j = i + (i & -i);
            if (j <= n) {
                info[j] += info[i];
            }
        }
    }

    void add(int p, T x) {
        while (p <= n) {
            info[p] = info[p] + x;
            p += p & -p;
        }
    }

    T sum(int l, int r) { return sum(r) - sum(l - 1); }
    T sum(int p) {
        T s = T();
        while (p) {
            s = s + info[p];
            p -= p & -p;
        }
        return s;
    }

    int sumQuery(T x) {
        int pos = 0, l = 1;
        while (1 << l <= n) {
            l++;
        }
        for (int i = l - 1; i >= 0; i--) {
            int j = 1 << i;
            // rightmost
            if (pos + j <= n && info[pos + j] <= x) {
                pos += j;
                x -= info[pos];
            }
            // leftmost, info[pos + j] < x, return pos + 1;
        }
        return pos;
    }

private:
    int n;
    std::vector<T> info;
};

]], {}, { delimiters = "@$" })),

  s("segtree", fmt([[
template <class Info>
struct Segtree {
    int n;
    std::vector<Info> info;
    void update(int p) { info[p] = info[p * 2] + info[p * 2 + 1]; }

    Segtree() : n(0) {}
    Segtree(int n_, Info v_ = Info()) : Segtree(n_, std::vector(n_, v_)) {}

    template <class T>
    Segtree(std::vector<T> a_) {
        init(a_);
    }

    template <class T>
    void init(std::vector<T> a_) {
        n = a_.size();
        info.assign(4 << std::__lg(n), Info());
        std::function<void(int, int, int)> build = [&](int p, int l, int r) {
            if (r - l == 1) {
                info[p] = a_[l];
                return;
            }
            int m = (l + r) / 2;
            build(p * 2, l, m);
            build(p * 2 + 1, m, r);
            update(p);
        };
        build(1, 0, n);
    }

    void set(int p, const Info &v) { set(p, 1, 0, n, v); }
    void set(int x, int p, int l, int r, const Info &v) {
        if (r - l == 1) {
            info[p] = v;
            return;
        }

        int m = (l + r) / 2;
        if (x < m) {
            set(x, p * 2, l, m, v);
        } else {
            set(x, p * 2 + 1, m, r, v);
        }

        update(p);
    }

    Info query(int l, int r) const { return query(l, r, 1, 0, n); }
    Info query(int x, int y, int p, int l, int r) const {
        if (l >= y || r <= x) {
            return Info();
        }

        if (l >= x && r <= y) {
            return info[p];
        }

        int m = (l + r) / 2;
        return query(x, y, p * 2, l, m) + query(x, y, p * 2 + 1, m, r);
    }

    Info all() { return info[1]; }

    template <class F>
    int findFirst(int l, int r, F &&pred) {
        return findFirst(l, r, 1, 0, n, pred);
    }
    template <class F>
    int findFirst(int x, int y, int p, int l, int r, F &&pred) {
        if (l >= y || r <= x || !pred(info[p])) {
            return -1;
        }
        if (r - l == 1) {
            return l;
        }
        int m = (l + r) / 2;
        int ans = findFirst(x, y, p * 2, l, m, pred);
        if (ans == -1) {
            ans = findFirst(x, y, p * 2 + 1, m, r, pred);
        }
        return ans;
    }

    template <class F>
    int findLast(int l, int r, F &&pred) {
        return findLast(l, r, 1, 0, n, pred);
    }
    template <class F>
    int findLast(int x, int y, int p, int l, int r, F &&pred) {
        if (l >= y || r <= x || !pred(info[p])) {
            return -1;
        }
        if (r - l == 1) {
            return l;
        }
        int m = (l + r) / 2;
        int res = findLast(x, y, p * 2 + 1, m, r, pred);
        if (res == -1) {
            res = findLast(x, y, p * 2, l, m, pred);
        }
        return res;
    }
};

struct Info {
    @$
    friend Info operator+(const Info &lhs, const Info &rhs) {
        @$
    }
};
]], { i(1), i(2) }, { delimiters = "@$" })),

  s("lazy_segtree", fmt([[
template <class Info, class Tag>
struct LazySegtree {
    int n;
    std::vector<Info> info;
    std::vector<Tag> tag;
    void update(int p) { info[p] = info[p * 2] + info[p * 2 + 1]; }

    void apply(int p, const Tag &t) {
        info[p].apply(t);
        tag[p].apply(t);
    }
    void push(int p) {
        apply(p * 2, tag[p]);
        apply(p * 2 + 1, tag[p]);
        tag[p] = Tag();
    }
    LazySegtree() : n(0) {}
    LazySegtree(int n_, Info v_ = Info())
        : LazySegtree(n_, std::vector(n_, v_)) {}

    template <class T>
    LazySegtree(std::vector<T> a_) : n(a_.size()) {
        init(a_);
    }

    template <class T>
    void init(std::vector<T> a_) {
        n = a_.size();
        info.assign(4 << std::__lg(n), Info());
        tag.assign(4 << std::__lg(n), Tag());
        std::function<void(int, int, int)> build = [&](int p, int l, int r) {
            if (r - l == 1) {
                info[p] = a_[l];
                return;
            }
            int m = (l + r) / 2;
            build(p * 2, l, m);
            build(p * 2 + 1, m, r);
            update(p);
        };
        build(1, 0, n);
    }
    void set(int p, const Info &v) { set(p, 1, 0, n, v); }
    void set(int x, int p, int l, int r, const Info &v) {
        if (r - l == 1) {
            info[l] = v;
            return;
        }
        int m = (l + r) / 2;
        push(p);
        if (x < m) {
            set(x, p * 2, l, m, v);
        } else {
            set(x, p * 2 + 1, m, r, v);
        }
        update(p);
    }

    void modify(int l, int r, const Tag &t) { modify(l, r, 1, 0, n, t); }
    void modify(int x, int y, int p, int l, int r, const Tag &t) {
        if (l >= y || r <= x) {
            return;
        }

        if (l >= x && r <= y) {
            apply(p, t);
            return;
        }
        push(p);
        int m = (l + r) / 2;
        modify(x, y, p * 2, l, m, t);
        modify(x, y, p * 2 + 1, m, r, t);
        update(p);
    }

    Info query(int l, int r) { return query(l, r, 1, 0, n); }
    Info query(int x, int y, int p, int l, int r) {
        if (l >= y || r <= x) {
            return Info();
        }
        if (l >= x && r <= y) {
            return info[p];
        }
        push(p);
        int m = (l + r) / 2;
        return query(x, y, p * 2, l, m) + query(x, y, p * 2 + 1, m, r);
    }

    Info all() { return info[1]; }

    template <class F>
    int findFirst(int l, int r, F &&pred) {
        return findFirst(l, r, 1, 0, n, pred);
    }
    template <class F>
    int findFirst(int x, int y, int p, int l, int r, F &&pred) {
        if (l >= y || r <= x || !pred(info[p])) {
            return -1;
        }
        if (r - l == 1) {
            return l;
        }
        int m = (l + r) / 2;
        int ans = findFirst(x, y, p * 2, l, m, pred);
        if (ans == -1) {
            ans = findFirst(x, y, p * 2 + 1, m, r, pred);
        }
        return ans;
    }

    template <class F>
    int findLast(int l, int r, F &&pred) {
        return findLast(l, r, 1, 0, n, pred);
    }
    template <class F>
    int findLast(int x, int y, int p, int l, int r, F &&pred) {
        if (l >= y || r <= x || !pred(info[p])) {
            return -1;
        }
        if (r - l == 1) {
            return l;
        }
        int m = (l + r) / 2;
        int res = findLast(x, y, p * 2 + 1, m, r, pred);
        if (res == -1) {
            res = findLast(x, y, p * 2, l, m, pred);
        }
        return res;
    }
};

struct Tag {
    @$
    void apply(const Tag &t) {
        @$
    }
};

struct Info {
    @$
    friend Info operator+(const Info &lhs, const Info &rhs) {
        @$
    }
    void apply(const Tag &t) {
        @$
    }
};
  ]], { i(1), i(2), i(3), i(4), i(5) }, { delimiters = "@$" })),
  s("euler_sieve", fmt([[
std::vector<int> minp, primes;

void sieve(int n) {
    minp.assign(n + 1, 0);
    primes.clear();

    for (int i = 2; i <= n; i++) {
        if (!minp[i]) {
            minp[i] = i;
            primes.push_back(i);
        }
        for (auto p : primes) {
            if (i * p > n) {
                break;
            }
            minp[i * p] = p;
            if (i % p == 0) {
                break;
            }
        }
    }
}
  ]], {}, { delimiters = "@$" })),
  s("qpow", fmt([[
template <class T>
T qpow(T a, i64 b) {
    T ans = 1;
    while (b) {
        if (b & 1) {
            ans *= a;
        }
        a *= a;
        b >>= 1;
    }
    return ans;
}
  ]], {}, { delimiters = "@$" })),
  s("exgcd", fmt([[
// inv: ax + by = gcd(a, b) = 1
// ax = 1 (mod b), by = 1 (mod a)
template <class T>
std::tuple<i64, T, T> exgcd(i64 a, i64 b) {
    if (b == 0) {
        return {a, 1, 0};
    }

    auto [gcd, y, x] = exgcd<T>(b, a % b);

    y -= a / b * x;
    return {gcd, x, y};
}

template <class T>
T inv(i64 a, i64 p) {
    return std::get<1>(exgcd<T>(a, p));
}
]], {}, { delimiters = "@$" })),

  s("scc", fmt([[
struct SCC {
    int n, idx, cnt;
    std::vector<std::vector<int>> adj;
    std::vector<int> dfn, low, bel, stk;

    SCC() {}
    SCC(int n_) { init(n_); }
    void init(int n_) {
        n = n_;
        adj.assign(n, {});
        dfn.assign(n, -1);
        low.resize(n);
        bel.assign(n, -1);
        stk.clear();
        idx = cnt = 0;
    }

    void addEdge(int u, int v) { adj[u].push_back(v); }

    void tarjan(int x) {
        dfn[x] = low[x] = idx++;
        stk.push_back(x);
        for (auto y : adj[x]) {
            if (dfn[y] == -1) {
                tarjan(y);
                low[x] = std::min(low[x], low[y]);
            } else if (bel[y] == -1) {
                low[x] = std::min(low[x], dfn[y]);
            }
        }

        if (dfn[x] == low[x]) {
            int y;
            do {
                y = stk.back();
                bel[y] = cnt;
                stk.pop_back();
            } while (y != x);
            cnt++;
        }
    }

    auto work() {
        for (int i = 0; i < n; i++) {
            if (dfn[i] == -1) {
                tarjan(i);
            }
        }
        return bel;
    }
};
]], {}, { delimiters = "@$" })),
  s("ebcc", fmt([[
struct EBCC {
    int n;
    std::vector<int> dfn, low, bel, stk;
    std::vector<std::vector<int>> adj;
    int idx, cnt;

    EBCC(int n) { init(n); }

    void init(int n_) {
        n = n_;
        adj.assign(n, {});
        dfn.assign(n, -1);
        low.resize(n);
        bel.resize(n, -1);
        stk.clear();
        idx = cnt = 0;
    }

    void addEdge(int x, int y) {
        if (x == y) {
            return;
        }

        adj[x].push_back(y);
        adj[y].push_back(x);
    }

    void tarjan(int x, int p) {
        dfn[x] = low[x] = idx++;
        stk.push_back(x);

        int f = 0;
        for (auto y : adj[x]) {
            if (y == p && f == 0) {
                f++;
                continue;
            }

            if (dfn[y] == -1) {
                tarjan(y, x);
                low[x] = std::min(low[x], low[y]);
            } else if (bel[y] == -1 && dfn[y] < dfn[x]) {
                low[x] = std::min(low[x], dfn[y]);
            }
        }

        if (dfn[x] == low[x]) {
            int y;
            do {
                y = stk.back();
                bel[y] = cnt;
                stk.pop_back();
            } while (y != x);
            cnt++;
        }
    }

    void work() {
        for (int i = 0; i < n; i++) {
            if (dfn[i] == -1) {
                tarjan(i, -1);
            }
        }
    }
};
]], {}, { delimiters = "@$" })),
  s("vbcc", fmt([[
struct VBCC {
    int n;
    std::vector<int> dfn, low, cut, stk;
    std::vector<std::vector<int>> adj, com;
    int idx, cnt;

    VBCC(int n) { init(n); }

    void init(int n_) {
        n = n_;
        dfn.assign(n, -1);
        cut.assign(n, -1);
        low.resize(n);
        stk.clear();
        adj.assign(n, {});
        idx = cnt = 0;
    }

    void addEdge(int x, int y) {
        if (x == y) {
            return;
        }
        adj[x].push_back(y);
        adj[y].push_back(x);
    }

    void tarjan(int x, int root) {
        if (adj[x].empty()) {
            cnt++;
            com.push_back({x});
            return;
        }

        dfn[x] = low[x] = idx++;
        stk.push_back(x);
        int f = 0;
        for (auto y : adj[x]) {
            if (dfn[y] == -1) {
                tarjan(y, x);
                low[x] = std::min(low[x], low[y]);
                if (low[y] >= dfn[x]) {
                    f++;
                    if (f > (x == root)) {
                        cut[x] = 1;
                    }

                    com.push_back({x});
                    int z;
                    do {
                        z = stk.back();
                        com[cnt].push_back(z);
                        stk.pop_back();
                    } while (z != y);
                    cnt++;
                }
            } else {
                low[x] = std::min(low[x], dfn[y]);
            }
        }
    }

    void work() {
        for (int i = 0; i < n; i++) {
            if (dfn[i] == -1) {
                tarjan(i, i);
            }
        }
    }
};
]], {}, { delimiters = "@$" })),
  s("spt", fmt([[
template <class T>
struct ST {
    ST() {}
    ST(int n_) { init(n_); }
    ST(const std::vector<T> &a) {
        init(a.size());
        build(a);
    }
    void init(int n_) {
        n = n_;
        log = std::log2(n_);
        f.assign(n, std::vector<T>(log + 1));
    }

    void build(const std::vector<T> &a) {
        assert(static_cast<int>(a.size()) == n);
        for (int i = 0; i < n; i++) {
            f[i][0] = a[i];
        }
        for (int j = 1; j <= log; j++) {
            for (int i = 0; i + (1 << j) - 1 < n; i++) {
                f[i][j] = f[i][j - 1] | f[i + (1 << (j - 1))][j - 1];
            }
        }
    }

    T query(int l, int r) {
        int k = std::log2(r - l + 1);
        return f[l][k] | f[r - (1 << k) + 1][k];
    }

    int n, log;
    std::vector<std::vector<T>> f;
};

struct Info {
    int v;
    friend Info operator|(const Info &a, const Info &b) {
        return {std::max(a.v, b.v)};
    }
};
]], {}, { delimiters = "@$" })),

  s("simpson", fmt([[
constexpr double EPS = 1E-9;

double f(double x) {
    return @$;
}

double simpson(double l, double r) {
    return (f(l) + f(r) + 4 * f((l + r) / 2)) * (r - l) / 6;
}

double integral(double l, double r, double eps, double st) {
    double m = (l + r) / 2;
    double sl = simpson(l, m);
    double sr = simpson(m, r);

    if (std::abs(sl + sr - st) <= 15 * EPS) {
        return sl + sr + (sl + sr - st) / 15;
    }

    return integral(l, m, eps / 2, sl) + integral(m, r, eps / 2, sr);
}

double integral(double l, double r) {
    return integral(l, r, EPS, simpson(l, r));
}
]], { i(1) }, { delimiters = "@$" })),
  s("fft", fmt([[
template <class F>
struct FFT {
    std::vector<int> rev;
    std::vector<std::complex<F>> roots;

    const F pi = std::acos(-1);

    std::complex<F> identity(int k) {
        return std::complex(std::cos(2 * pi / (1 << k)),
                            std::sin(2 * pi / (1 << k)));
    }
    void dft(std::vector<std::complex<F>> &a) {
        const int n = a.size();
        if (rev.size() != n) {
            const int k = __builtin_ctz(n) - 1;
            rev.resize(n);
            for (int i = 0; i < n; i++) {
                rev[i] = rev[i >> 1] >> 1 | (i & 1) << k;
            }
        }

        for (int i = 0; i < n; i++) {
            if (i < rev[i]) {
                std::swap(a[i], a[ rev[i] ]);
            }
        }

        if (roots.size() != n) {
            if (roots.empty()) {
                roots = {0, 1};
            }
            int k = __builtin_ctz(roots.size());
            roots.resize(n);
            while (1 << k < n) {
                auto e = identity(k + 1);
                for (int i = 1 << (k - 1); i < 1 << k; i++) {
                    roots[2 * i] = roots[i];
                    roots[2 * i + 1] = roots[i] * e;
                }
                k++;
            }
        }

        for (int k = 1; k < n; k *= 2) {
            for (int i = 0; i < n; i += 2 * k) {
                for (int j = 0; j < k; j++) {
                    auto x = a[i + j], y = a[i + j + k] * roots[k + j];
                    a[i + j] = x + y;
                    a[i + j + k] = x - y;
                }
            }
        }
    }

    void idft(std::vector<std::complex<F>> &a) {
        dft(a);
        const int n = a.size();
        std::reverse(a.begin() + 1, a.end());
        for (int i = 0; i < n; i++) {
            a[i] /= n;
        }
    }
};

template <class F>
std::vector<F> &operator*=(std::vector<F> &a, const std::vector<F> &b) {
    static FFT<F> fft;
    int n = a.size(), m = b.size();
    if (std::min(n, m) == 0) {
        return a = {};
    }

    int tot = n + m - 1;
    if (std::min(n, m) < 128) {
        std::vector<F> c(tot);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                c[i + j] += a[i] * b[j];
            }
        }

        return a = std::move(c);
    }

    int siz = 1;
    while (siz < tot) {
        siz *= 2;
    }

    a.resize(siz);
    std::vector<std::complex<F>> c(a.begin(), a.end()), d(b.begin(), b.end());
    d.resize(siz);
    fft.dft(c);
    fft.dft(d);
    for (int i = 0; i < siz; i++) {
        c[i] *= d[i];
    }

    fft.idft(c);

    for (int i = 0; i < tot; i++) {
        a[i] = c[i].real();
    }
    return a;
}

template <class F>
std::vector<F> operator*(const std::vector<F> &a, const std::vector<F> &b) {
    return std::vector<F>{a} *= b;
}
]], {}, { delimiters = "@$" })),
  s("ntt", fmt([[
struct NTT {
    std::vector<int> rev;
    std::vector<Z> roots;

    Z identity(int k) {
        assert(mod == 998244353);
        return Z(3).pow((mod - 1) >> k);
    }
    void dft(std::vector<Z> &a) {
        const int n = a.size();
        if (rev.size() != n) {
            const int k = __builtin_ctz(n) - 1;
            rev.resize(n);
            for (int i = 0; i < n; i++) {
                rev[i] = rev[i >> 1] >> 1 | (i & 1) << k;
            }
        }

        for (int i = 0; i < n; i++) {
            if (i < rev[i]) {
                std::swap(a[i], a[ rev[i] ]);
            }
        }

        if (roots.size() != n) {
            if (roots.empty()) {
                roots = {0, 1};
            }
            int k = __builtin_ctz(roots.size());
            roots.resize(n);
            while (1 << k < n) {
                auto e = identity(k + 1);
                for (int i = 1 << (k - 1); i < 1 << k; i++) {
                    roots[2 * i] = roots[i];
                    roots[2 * i + 1] = roots[i] * e;
                }
                k++;
            }
        }

        for (int k = 1; k < n; k *= 2) {
            for (int i = 0; i < n; i += 2 * k) {
                for (int j = 0; j < k; j++) {
                    Z x = a[i + j], y = a[i + j + k] * roots[k + j];
                    a[i + j] = x + y;
                    a[i + j + k] = x - y;
                }
            }
        }
    }

    void idft(std::vector<Z> &a) {
        dft(a);
        const int n = a.size();
        std::reverse(a.begin() + 1, a.end());
        for (int i = 0; i < n; i++) {
            a[i] /= n;
        }
    }
} ntt;

std::vector<Z> &operator*=(std::vector<Z> &a, const std::vector<Z> &b) {
    int n = a.size(), m = b.size();
    if (std::min(n, m) == 0) {
        return a = {};
    }

    int tot = n + m - 1;
    if (std::min(n, m) < 128) {
        std::vector<Z> c(tot);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                c[i + j] += a[i] * b[j];
            }
        }

        return a = std::move(c);
    }

    int siz = 1;
    while (siz < tot) {
        siz *= 2;
    }

    std::vector c(b.begin(), b.end());
    a.resize(siz);
    c.resize(siz);

    ntt.dft(a);
    ntt.dft(c);
    for (int i = 0; i < siz; i++) {
        a[i] *= c[i];
    }

    ntt.idft(a);
    a.resize(tot);
    return a;
}
]], {}, { delimiters = "@$" })),
  s("poly", fmt([[
template <class T>
struct Poly {
    std::vector<T> a;
    Poly() {}
    explicit Poly(
        int size,
        std::function<T(int)> f = [](int) { return T{}; })
        : a(size) {
        for (int i = 0; i < size; i++) {
            a[i] = f(i);
        }
    }
    explicit Poly(int size, std::function<T(void)> f) : a(size) {
        for (int i = 0; i < size; i++) {
            a[i] = f();
        }
    }
    Poly(const std::vector<T> &a) : a(a) {}
    Poly(const std::initializer_list<T> &a) : a(a) {}
    int size() const { return a.size(); }
    void resize(int n) { a.resize(n); }
    T operator[](int idx) const {
        if (idx < a.size()) {
            return a[idx];
        }
        return {};
    }
    T &operator[](int idx) {
        if (a.size() < idx + 1) {
            a.resize(idx + 1);
        }
        return a[idx];
    }
    Poly mulxk(int k) const {
        auto b = a;
        b.insert(b.begin(), k, T{});
        return b;
    }
    Poly modxk(int k) const {
        k = std::min(size(), k);
        return std::vector(a.begin(), a.begin() + k);
    }
    Poly divxk(int k) const {
        if (size() <= k) {
            return {};
        }
        return std::vector(a.begin() + k, a.end());
    }

    Poly<T> &operator+=(const Poly<T> &b) {
        a.resize(std::max(size(), b.size()));
        for (int i = 0; i < b.size(); i++) {
            a[i] += b[i];
        }
        return *this;
    }
    Poly<T> &operator-=(const Poly<T> &b) {
        a.resize(std::max(size(), b.size()));
        for (int i = 0; i < b.size(); i++) {
            a[i] -= b[i];
        }
        return *this;
    }
    Poly<T> &operator*=(const Poly<T> &b) {
        a *= b.a;
        return *this;
    }
    Poly<T> &operator*=(T b) {
        for (int i = 0; i < size(); i++) {
            a[i] *= b;
        }
        return *this;
    }

    Poly<T> &operator/=(T b) {
        for (int i = 0; i < size(); i++) {
            a[i] /= b;
        }
        return *this;
    }

    friend Poly<T> operator+(const Poly<T> &a, const Poly<T> &b) {
        return Poly{a} += b;
    }
    friend Poly<T> operator-(const Poly<T> &a, const Poly<T> &b) {
        return Poly{a} -= b;
    }

    friend Poly<T> operator*(const Poly<T> &a, const Poly<T> &b) {
        return Poly{a} *= b;
    }

    friend Poly<T> operator*(T a, const Poly<T> &b) { return Poly{b} *= a; }

    friend Poly<T> operator*(const Poly<T> &a, T b) { return Poly{a} *= b; }

    friend Poly<T> operator/(const Poly<T> &a, T b) { return Poly{a} /= b; }

    Poly<T> deriv() const {
        if (a.empty()) {
            return {};
        }
        std::vector<T> ans(size() - 1);
        for (int i = 0; i < size() - 1; ++i) {
            ans[i] = (i + 1) * a[i + 1];
        }
        return ans;
    }
    Poly<T> integr() const {
        std::vector<T> ans(size() + 1);
        for (int i = 0; i < size(); i++) {
            ans[i + 1] = a[i] / (i + 1);
        }
        return ans;
    }
    Poly<T> inv(int m) const {
        Poly ans{a[0].inv()};
        int k = 1;
        while (k < m) {
            k *= 2;
            ans = (ans * (Poly<T>{2} - ans * modxk(k))).modxk(k);
        }
        return ans.modxk(m);
    }
    Poly<T> sqrt(int m) const {
        // Note: assert a[0] = 1
        Poly ans{1};
        int k = 1;
        while (k < m) {
            k *= 2;
            ans = (ans / 2 + modxk(k) * ans.inv(k) / 2).modxk(k);
        }
        return ans.modxk(m);
    }

    Poly<T> log(int m) const { return (deriv() * inv(m)).integr().modxk(m); }
    Poly<T> exp(int m) const {
        Poly ans{1};
        int k = 1;
        while (k < m) {
            k *= 2;
            ans = (ans * (Poly{1} - ans.log(k) + modxk(k))).modxk(k);
        }
        return ans.modxk(m);
    }
};
]], {}, { delimiters = "@$" })),
}
