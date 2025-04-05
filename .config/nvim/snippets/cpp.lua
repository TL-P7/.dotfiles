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
}

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
    explicit DSU() : n(0) {}
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
    explicit Mint() : _x(0) {}

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
    explicit Mint() : _x(0) {}

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

    explicit Matrix(int n) : Matrix(n, n) {}
    explicit Matrix(int r, int c) : r(r), c(c) {
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
struct LCA {
    std::vector<std::vector<int>> adj;
    std::vector<std::vector<int>> f;
    std::vector<int> dep;
    int n;
    int root;
    int U;
    // in case size = 1
    LCA(int size, int root_)
        : adj(size + 1),
          dep(size + 1),
          n(size),
          root(root_),
          U(std::__lg(size) + 1) {
        f.assign(size + 1, std::vector<int>(U + 1));
        dep[root] = 1;
    }
    void add_edge(int u, int v) { adj[u].emplace_back(v); }
    void add_edges(int u, int v) {
        add_edge(u, v);
        add_edge(v, u);
    }
    int up(int x, int k) {
        for (int i = 0; k; k /= 2, i++) {
            if (k & 1) {
                x = f[x][i];
            }
        }
        return x;
    }
    void dfs(int u) {
        for (auto v : adj[u]) {
            if (!dep[v]) {
                f[v][0] = u;
                dep[v] = dep[u] + 1;
                dfs(v);
            }
        }
    }
    void build() {
        dfs(root);
        for (int i = 1; i <= U; i++) {
            for (int j = 1; j <= n; j++) {
                f[j][i] = f[ f[j][i - 1] ][i - 1];
            }
        }
    }
    int operator()(int x, int y) {
        if (dep[x] < dep[y]) {
            std::swap(x, y);
        }
        int diff = dep[x] - dep[y];
        x = up(x, diff);
        if (x == y) {
            return x;
        }
        for (int i = U; i >= 0; i--) {
            int lp = f[x][i];
            int rp = f[y][i];
            if (lp != rp) {
                x = lp;
                y = rp;
            }
        }
        return f[x][0];
    }
};
]], {}, { delimiters = "@#" })),

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
    Segtree() : n(0) {}
    Segtree(int n_, Info v_ = Info())
        : Segtree(n_, std::vector(n_ + 1, v_)) {}

    template <class T>
    explicit Segtree(int n_, std::vector<T> a_) : n(n_) {
        init(n_, a_);
    }

    template <class T>
    void init(int n_, std::vector<T> a_) {
        size = bit_ceil(n_);
        log = __builtin_ctz(size);
        info.assign(size * 2, Info());
        std::function<void(int, int, int)> build = [&](int id, int l, int r) {
            if (l == r) {
                info[id] = a_[l];
                return;
            }
            int m = (l + r) / 2;
            build(id * 2, l, m);
            build(id * 2 + 1, m + 1, r);
            update(id);
        };
        build(1, 1, n_);
    }

    void set(int p, const Info &v) { set(p, v, 1, 1, n); }
    void set(int p, const Info &v, int id, int l, int r) {
        if (l == r) {
            info[id] = v;
            return;
        }
        int m = (l + r) / 2;
        if (p <= m) {
            set(p, v, id * 2, l, m);
        } else {
            set(p, v, id * 2 + 1, m + 1, r);
        }
        update(id);
    }

    Info query(int ql, int qr) const { return query(ql, qr, 1, 1, n); }
    Info query(int ql, int qr, int id, int l, int r) const {
        if (l == ql && r == qr) {
            return info[id];
        }
        int m = (l + r) / 2;
        if (qr <= m) {
            return query(ql, qr, id * 2, l, m);
        } else if (ql > m) {
            return query(ql, qr, id * 2 + 1, m + 1, r);
        } else {
            return query(ql, m, id * 2, l, m) +
                   query(m + 1, qr, id * 2 + 1, m + 1, r);
        }
    }
    Info all() {
        return info[1];
    }

    template <class F>
    int find_first(int ql, int qr, F &&pred) {
        return find_first(ql, qr, 1, 1, n, pred);
    }
    template <class F>
    int find_first(int ql, int qr, int id, int l, int r, F &&pred) {
        if (l > qr || r < ql || !pred(info[id])) {
            return -1;
        }
        if (l == r) {
            return id;
        }
        int m = (l + r) / 2;
        int res = find_first(ql, qr, id * 2, l, m, pred);
        if (res == -1) {
            res = find_first(ql, qr, id * 2 + 1, m + 1, r, pred);
        }
        return res;
    }

    template <class F>
    int find_last(int ql, int qr, F &&pred) {
        return find_last(ql, qr, 1, 1, n, pred);
    }
    template <class F>
    int find_last(int ql, int qr, int id, int l, int r, F &&pred) {
        if (l > qr || r < ql || !pred(info[id])) {
            return -1;
        }
        if (l == r) {
            return id;
        }
        int m = (l + r) / 2;
        int res = find_last(ql, qr, id * 2 + 1, m + 1, r, pred);
        if (res == -1) {
            res = find_last(ql, qr, id * 2, l, m, pred);
        }
        return res;
    }

private:
    int n, size, log;
    std::vector<Info> info;
    unsigned int bit_ceil(unsigned int n) {
        unsigned int x = 1;
        while (x < (unsigned int)(n)) {
            x *= 2;
        }
        return x;
    }
    void update(int p) { info[p] = info[p * 2] + info[p * 2 + 1]; }
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
    LazySegtree() : n(0) {}
    LazySegtree(int n_, Info v_ = Info())
        : LazySegtree(n_, std::vector(n_ + 1, v_)) {}

    template <class T>
    explicit LazySegtree(int n_, std::vector<T> a_) : n(n_) {
        init(n_, a_);
    }

    template <class T>
    void init(int n_, std::vector<T> a_) {
        size = bit_ceil(n_);
        log = __builtin_ctz(size);
        info.assign(size * 2, Info());
        tag.assign(size * 2, Tag());
        std::function<void(int, int, int)> build = [&](int id, int l, int r) {
            if (l == r) {
                info[id] = a_[l];
                return;
            }
            int m = (l + r) / 2;
            build(id * 2, l, m);
            build(id * 2 + 1, m + 1, r);
            update(id);
        };
        build(1, 1, n_);
    }
    void set(int p, const Info &v) { set(p, v, 1, 1, n); }
    void set(int p, const Info &v, int id, int l, int r) {
        if (l == r) {
            info[l] = v;
            return;
        }
        int m = (l + r) / 2;
        push(id);
        if (p <= m) {
            set(p, v, id * 2, l, m);
        } else {
            set(p, v, id * 2 + 1, m + 1, r);
        }
        update(id);
    }

    void modify(int ml, int mr, const Tag &t) { modify(ml, mr, t, 1, 1, n); }
    void modify(int ml, int mr, const Tag &t, int id, int l, int r) {
        if (l == ml && r == mr) {
            apply(id, t);
            return;
        }
        push(id);
        int m = (l + r) / 2;
        if (mr <= m) {
            modify(ml, mr, t, id * 2, l, m);
        } else if (ml > m) {
            modify(ml, mr, t, id * 2 + 1, m + 1, r);
        } else {
            modify(ml, m, t, id * 2, l, m);
            modify(m + 1, mr, t, id * 2 + 1, m + 1, r);
        }
        update(id);
    }

    Info query(int ql, int qr) { return query(ql, qr, 1, 1, n); }
    Info query(int ql, int qr, int id, int l, int r) {
        if (l == ql && r == qr) {
            return info[id];
        }
        push(id);
        int m = (l + r) / 2;
        if (qr <= m) {
            return query(ql, qr, id * 2, l, m);
        } else if (ql > m) {
            return query(ql, qr, id * 2 + 1, m + 1, r);
        } else {
            return query(ql, m, id * 2, l, m) +
                   query(m + 1, qr, id * 2 + 1, m + 1, r);
        }
    }
    Info all() {
        return info[1];
    }

    template <class F>
    int find_first(int ql, int qr, F &&pred) {
        return find_first(ql, qr, 1, 1, n, pred);
    }
    template <class F>
    int find_first(int ql, int qr, int id, int l, int r, F &&pred) {
        if (l > qr || r < ql || !pred(info[id])) {
            return -1;
        }
        if (l == r) {
            return id;
        }
        push(id);
        int m = (l + r) / 2;
        int res = find_first(ql, qr, id * 2, l, m, pred);
        if (res == -1) {
            res = find_first(ql, qr, id * 2 + 1, m + 1, r, pred);
        }
        return res;
    }

    template <class F>
    int find_last(int ql, int qr, F &&pred) {
        return find_last(ql, qr, 1, 1, n, pred);
    }
    template <class F>
    int find_last(int ql, int qr, int id, int l, int r, F &&pred) {
        if (l > qr || r < ql || !pred(info[id])) {
            return -1;
        }
        if (l == r) {
            return id;
        }
        push(id);
        int m = (l + r) / 2;
        int res = find_last(ql, qr, id * 2 + 1, m + 1, r, pred);
        if (res == -1) {
            res = find_last(ql, qr, id * 2, l, m, pred);
        }
        return res;
    }

private:
    int n, size, log;
    std::vector<Info> info;
    std::vector<Tag> tag;
    unsigned int bit_ceil(unsigned int n) {
        unsigned int x = 1;
        while (x < (unsigned int)(n)) {
            x *= 2;
        }
        return x;
    }
    void update(int id) { info[id] = info[id * 2] + info[id * 2 + 1]; }
    void apply(int id, const Tag &t) {
        info[id].apply(t);
        tag[id].apply(t);
    }
    void push(int id) {
        apply(id * 2, tag[id]);
        apply(id * 2 + 1, tag[id]);
        tag[id] = Tag();
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
<template class T>
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
i64 exgcd(i64 a, i64 b, i64 &x, i64 &y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }

    i64 gcd = exgcd(a, b, y, x);
    y -= a / b * x;

    return gcd;
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


  -- construction
  s("head", {
    t({ "#pragma once", "", "#ifndef " ..
    vim.fn.expand("%:r"):upper() ..
    "__H", "#define " .. vim.fn.expand("%:r"):upper() .. "__H", "", "class " })
    , i(1, vim.fn.expand("%:r")), t({ " {};", "", "#endif" }) }),
}
