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


return {
  s("tem", fmt([[
    #include <bits/stdc++.h>

    using ll = long long;
    using PII = std::pair<int, int>;
    using ld = long double;
    using i128 = __int128;

    int main() {
        std::ios::sync_with_stdio(false);
        std::cin.tie(nullptr);

        @$
    }
  ]], { i(1) }, { delimiters = "@$" })),

  s("cf", fmt([[
    #include <bits/stdc++.h>

    using ll = long long;
    using PII = std::pair<int, int>;
    using ld = long double;
    using i128 = __int128;

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
    int len = s.size();
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
    "while (i + z[i] < len && s[i + z[i]] == s[1 + z[i]]) {\n"
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
    // one-base
    t = " " + t;
    int len = t.size() << 1;
    s.resize(len);
    s[1] = '#';
    for (int i = 1, __ = t.size(); i < __; i++) {
        s[i << 1] = t[i];
        s[i << 1 | 1] = '#';
    }
    std::vector<int> p(len);
    int m = 0, r = 0;
    p[1] = 1;
    for (int i = 1; i < len; i++) {
        if (i > r) {
            p[i] = 1;
        } else {
            p[i] = std::min(r - i + 1, p[(m << 1) - i]);
        }
    ]]
    ..
    "while (i + p[i] < len && i - p[i] > 0 && s[i + p[i]] == s[i - p[i]]) {\n"
    ..
    [[
            p[i]++;
        }
        if (i + p[i] - 1 > r) {
            m = i;
            r = i + p[i] - 1;
        }
    }
    ]], {}, { delimiters = "@$" })),

  s("kmp", fmt([[
    for (int i = 1, j = 0; i < n; i++) {
        while (j && p[i] != p[j]) {
            j = next[j];
        }
        if (p[i] == p[j]) {
            j++;
        }
        next[i + 1] = j;
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

  s("noweight_graph", fmta([[
struct Graph {
    explicit Graph(int _n) : n(_n), adj(_n + 1) {}
    void add_edge(int u, int v) { adj[u].emplace_back(v); }
    void add_edges(int u, int v) {
        adj[u].emplace_back(v);
        adj[v].emplace_back(u);
    }
    std::vector<std::vector<int>> adj;
    int n;
};
  ]], {}, { delimiters = "@$" })),

  s("weight_graph", fmta([[
template <class T>
struct Graph {
    explicit Graph(int _n) : n(_n), adj(_n + 1), wgt(_n + 1) {}
    void add_edge(int u, int v, T w) {
        adj[u].emplace_back(v);
        wgt[u].emplace_back(w);
    }
    void add_edges(int u, int v, T w) {
        adj[u].emplace_back(v);
        wgt[u].emplace_back(w);
        adj[v].emplace_back(u);
        wgt[v].emplace_back(w);
    }
    std::vector<std::vector<int>> adj;
    std::vector<std::vector<T>> wgt;
    int n;
};
  ]], {}, { delimiters = "@$" })),

  s("ordered_edges", fmta([[
template <class T>
struct OEdges {
    int W;
    std::vector<std::vector<PII>> edges;
    explicit OEdges(T maxWeight) : W(maxWeight), edges(maxWeight + 1) {}
    void add_edge(T weight, int u, int v) { edges[weight].push_back({u, v}); }
};
  ]], {}, { delimiters = "@$" })),

  s("dsu", fmta([[
struct Dsu {
    explicit Dsu() : n(0) {}
    explicit Dsu(int _n) : n(_n), p(_n + 1, -1) {}


    int root(int x) { return p[x] < 0 ? x : p[x] = root(p[x]); }
    // return the root for next merge
    int merge(int x, int y) {
        int rx = root(x), ry = root(y);
        if (rx == ry) {
            return rx;
        }
        // size_ry > size_rx
        if (p[rx] > p[ry]) {
            std::swap(rx, ry);
            std::swap(x, y);
        }
        // merge ry to rx
        p[rx] += p[ry];
        p[ry] = rx;
        return rx;
    }
    bool same(int x, int y) { return root(x) == root(y); }
    int size(int x) { return -p[root(x)]; }
private:
    int n;
    std::vector<int> p;
};
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
template <ll _mod>
struct Mint {
public:
    Mint(ll x) : _x(x % _mod) { norm(x); }
    explicit Mint() : _x(0) {}

    static ll getmod() {
        return _mod;
    }

    constexpr ll val() const {
        return _x;
    }

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

    // the same as std::vector v2(v1)
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

    Mint pow(ll times) const {
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

    Mint inv() const { return this->pow(mod - 2); }
    friend constexpr std::istream &operator>>(std::istream &is, Mint &mint) {
        is >> mint._x;
        norm(mint._x %= _mod);
        return is;
    }
    friend constexpr std::ostream &operator<<(std::ostream &os, const Mint &mint) {
        return os << mint._x;
    }

private:
    ll _x;
    static ll norm(ll &x) {
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
    Mint(ll x) : _x(x % _mod) { norm(_x); }
    Mint(ll x, ll mod) : _x(x) { _mod = mod, norm(x %= mod); }
    explicit Mint() : _x(0) {}

    static ll _mod;
    static ll getmod() { return _mod; }
    static void setmod(ll mod) { _mod = mod; }

    ll val() const { return _x; }

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

    // the same as std::vector v2(v1)
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

    Mint pow(ll times) const {
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

    Mint inv() const { return this->pow(getmod() - 2); }

    friend std::istream &operator>>(std::istream &is, Mint &mint) {
        is >> mint._x;
        norm(mint._x %= _mod);
        return is;
    }
    friend std::ostream &operator<<(std::ostream &os, const Mint &mint) {
        return os << mint._x;
    }

private:
    ll _x;
    static ll norm(ll &x) {
        if (x < 0) {
            x += _mod;
        } else if (x >= _mod) {
            x -= _mod;
        }
        return x;
    }
};

using Z = Mint;
ll Z::_mod;
ll mod;
]], {}, { delimiters = "@$" })),
  s("matrix", fmt([[
template <class T = int>
struct Matrix {
    Matrix() : _r(0), _c(0) {}
    explicit Matrix(int r, int c, std::vector<std::vector<T>> &m)
        : _r(r), _c(c), _m(m) {}

    explicit Matrix(int n) : Matrix(n, n) {}
    explicit Matrix(int r, int c) : _r(r), _c(c) {
        _m = std::vector<std::vector<T>>(r, std::vector<T>(c));
    }
    explicit Matrix(std::vector<std::vector<T>> &m) : _m(m) {
        assert(m.size() > 0 && m[0].size() > 0);
        _r = m.size();
        _c = m[0].size();
    }
    constexpr T at(int i, int j) const {
        // one-base
        return _m[i - 1][j - 1];
    }
    constexpr T &get(int i, int j) { return _m[i - 1][j - 1]; }
    static constexpr Matrix identity(int n) {
        Matrix ret(n);
        for (int i = 0; i < n; i++) {
            ret._m[i][i] = 1;
        }
        return ret;
    }
    constexpr bool square() { return this->_c == this->_r; }
    constexpr Matrix pow(ll n) {
        assert(this->square());
        Matrix ret(identity(this->_c));
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
    static constexpr Matrix fast(std::vector<T> &a) {
        Matrix ret(a.size());
        for (int i = 0; i < ret._r - 1; i++) {
            ret._m[i + 1][i] = 1;
        }
        int lst = ret._c - 1;
        for (int i = 0; i < ret._r; i++) {
            ret._m[i][lst] = a[i];
        }
        return ret;
    }
    constexpr Matrix &operator*=(const Matrix &rhs) {
        return *this = *this * rhs;
    }
    friend constexpr Matrix operator*(const Matrix &lhs, const Matrix &rhs) {
        assert(lhs._c == rhs._r);
        Matrix ret(lhs._r, rhs._c);
        for (int i = 0; i < lhs._r; i++) {
            for (int j = 0; j < lhs._c; j++) {
                if (lhs._m[i][j] != 0) {
                    for (int k = 0; k < rhs._c; k++) {
                        if (rhs._m[j][k] != 0) {
                            ret._m[i][k] += lhs._m[i][j] * rhs._m[j][k];
                        }
                    }
                }
            }
        }
        return ret;
    }
    friend constexpr std::istream &operator>>(std::istream &is,
                                              Matrix &matrix) {
        is >> matrix._r >> matrix._c;
        for (int i = 0; i < matrix._r; i++) {
            for (int j = 0; j < matrix._c; j++) {
                is >> matrix._m[i][j];
            }
        }
        return is;
    }
    friend constexpr std::ostream &operator<<(std::ostream &os,
                                              const Matrix m) {
        for (int i = 0; i < m._r; i++) {
            for (int j = 0; j < m._c; j++) {
                os << m._m[i][j] << " \n"[j == m._c - 1];
            }
        }
        return os;
    }

private:
    std::vector<std::vector<T>> _m;
    int _r, _c;
};
]], {}, { delimiters = "@$" })),

  s("char_trie", fmt([[
template <class T>
struct Trie {
    Trie(int n, int l, int suf) : _l(l), _suf(suf){
        _size =  suf_ceil(n) + n * _lz;
        _son = std::vector<std::vector<int>>(_size, std::vector<int>(suf));
        _times = std::vector<T>(_size);
    }
    Trie(int suml, int suf)
        : _size(suml + 1), _son(_size, std::vector<int>(suf)), _times(_size) {}

    T query(const std::string &x) const {
        int p = 0;
        for (auto ch : x) {
            int s = ch - 'a';
            if (!_son[p][s]) {
                return 0;
            }
            p = _son[p][s];
        }
        return _times[p];
    }
    void insert(const std::string &x) {
        int p = 0;
        for (auto ch : x) {
            int s = ch - 'a';
            if (!_son[p][s]) {
                _son[p][s] = ++cnt;
            }
            p = _son[p][s];
        }
        _times[p]++;
    }

private:
    int _size, _l, _suf, _lz;
    std::vector<std::vector<int>> _son;
    std::vector<T> _times;
    int cnt = 0;
    unsigned int suf_ceil(unsigned int n) {
        unsigned int x = 1;
        int i;
        for (i = -1; x < n; i++) {
            x *= _suf;
        }
        _lz = _l - i;
        return x;
    }
};
    ]], {}, { delimiters = "@$" }))
  ,
  s("int_trie", fmt([[
template <class T>
struct Trie {
    Trie(int n, int l, int suf) : _l(l), _suf(suf){
        _size =  suf_ceil(n) + n * _lz;
        _son = std::vector<std::vector<int>>(_size, std::vector<int>(suf));
        _times = std::vector<T>(_size);
    }
    Trie(int suml, int suf)
        : _size(suml + 1), _son(_size, std::vector<int>(suf)), _times(_size) {}

    T query(const int x) const {
        int p = 0;
        for (int i = 31; i >= 0; i--) {
            int s = (x >> i) & 1;
            if (!_son[p][s]) {
                return 0;
            }
            p = _son[p][s];
        }
        return _times[p];
    }
    void insert(const int x) {
        int p = 0;
        for (int i = 31; i >= 0; i--) {
            int s = (x >> i) & 1;
            if (!_son[p][s]) {
                _son[p][s] = ++cnt;
            }
            p = _son[p][s];
        }
        _times[p]++;
    }
    int xor_max(const int x) const {
        int ans = 0;
        int p = 0;
        for (int i = 31; i >= 0; i--) {
            int b = (x >> i) & 1;
            if (_son[p][!b]) {
                ans = ans * 2 + 1;
                p = _son[p][!b];
            } else {
                ans *= 2;
                p = _son[p][b];
            }
        }
        return ans;
    }

private:
    int _size, _l, _suf, _lz;
    std::vector<std::vector<int>> _son;
    std::vector<T> _times;
    int cnt = 0;
    unsigned int suf_ceil(unsigned int n) {
        unsigned int x = 1;
        int i;
        for (i = -1; x < n; i++) {
            x *= _suf;
        }
        _lz = _l - i;
        return x;
    }
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
        assert(_n >= n && n >= k && k >= 0);
        init(n);
        return _fac[n] * _facinv[n] * _facinv[n - k];
    }

private:
    int _n;
    std::vector<Z> _fac;
    std::vector<Z> _inv;
    std::vector<Z> _facinv;
};
  ]], {}, { delimiters = "@$" })),

  s("rw", fmt([[
template <typename t>
t read() {
    t x = 0;
    char sign = 1;
    char ch = std::cin.get();
    while (!isdigit(ch)) {
        if (ch == '-') {
            sign *= -1;
        }
        ch = std::cin.get();
    }
    while (isdigit(ch)) {
        x = x * 10 + ch - '0';
        ch = std::cin.get();
    }
    return sign * x;
}

template <typename t>
void write(t x) {
    if (x < 0) {
        std::cout << '-';
        x *= -1;
    }
    char stk[100], top = 0;
    do {
        stk[++top] = x % 10 + '0';
        x /= 10;
    } while (x);
    while (top) {
        std::cout << stk[top--];
    }
}
  ]], {}, { delimiters = "@$" })),

  s("lca", fmt([[
template <class T = int>
struct Lca {
    std::vector<std::vector<T>> adj;
    std::vector<std::vector<int>> p;
    std::vector<T> dep;
    T n;
    T root;
    int max_pow;
    // in case size = 1
    Lca(T size, T _root)
        : adj(size + 1),
          dep(size + 1),
          n(size),
          root(_root),
          max_pow((int)log2(size) + 1) {
        p = std::vector<std::vector<int>>(size + 1,
                                          std::vector<int>(max_pow + 1));
    }
    Lca(T size)
        : adj(size + 1), dep(size + 1), n(size), max_pow((int)log2(size) + 1) {
        p = std::vector<std::vector<int>>(size + 1,
                                          std::vector<int>(max_pow + 1));
    }
    void add_edge(int u, int v) { adj[u].emplace_back(v); }
    void add_edges(int u, int v) {
        adj[u].emplace_back(v);
        adj[v].emplace_back(u);
    }
    T up(T x, int k) {
        for (int i = 0; k; i++, k >>= 1) {
            if (k & 1) {
                x = p[x][i];
            }
        }
        return x;
    }
    void dfs(T now, T pre = -1, int d = 0) {
        dep[now] = d;
        if (pre != -1) {
            p[now][0] = pre;
        }
        for (auto to : adj[now]) {
            if (to != pre) {
                dfs(to, now, d + 1);
            }
        }
    }
    void init() {
        dfs(root);
        for (int i = 1; i <= max_pow; i++) {
            for (T j = 1; j <= n; j++) {
                p[j][i] = p[ p[j][i - 1] ][i - 1];
            }
        }
    }
    T operator()(T lhs, T rhs) {
        if (dep[lhs] < dep[rhs]) {
            std::swap(lhs, rhs);
        }
        int diff = dep[lhs] - dep[rhs];
        lhs = up(lhs, diff);
        if (lhs == rhs) {
            return lhs;
        }
        for (int i = max_pow; i >= 0; i--) {
            T lp = p[lhs][i];
            T rp = p[rhs][i];
            if (lp != rp) {
                lhs = lp;
                rhs = rp;
            }
        }
        return p[lhs][0];
    }
};
]], {}, { delimiters = "@#" })),

  s("fenwick_tree", fmt([[
template <class Info>
struct FenwickTree {
    FenwickTree() : n(0) {}
    explicit FenwickTree(int n_) : n(n_), info(n + 1) {}

    void add(int p, Info x) {
        while (p <= n) {
            info[p] += x;
            p += p & -p;
        }
    }
    Info sum(int l, int r) { return sum(r) - sum(l - 1); }
    int query(Info x) {
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
        }
        return pos;
    }


private:
    int n;
    std::vector<Info> info;

    Info sum(int p) {
        Info s = 0;
        while (p) {
            s += info[p];
            p -= p & -p;
        }
        return s;
    }
};
]], {}, { delimiters = "@$" })),

  s("segtree", fmt([[
template <class Info>
struct Segtree {
    Segtree() : n(0) {}
    explicit Segtree(int n_, Info v_ = Info())
        : Segtree(n_, std::vector(n_, v_)) {}

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
        int res = find_first(ql, qr, id * 2 + 1, m + 1, r, pred);
        if (res == -1) {
            res = find_first(ql, qr, id * 2, l, m, pred);
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
    int x;

    friend Info operator+(const Info &lhs, const Info &rhs) {
        return {lhs.x + rhs.x};
    }
};
]], {}, { delimiters = "@$" })),

  s("lazy_segtree", fmt([[
template <class Info, class Tag>
struct LazySegtree {
    LazySegtree() : n(0) {}
    explicit LazySegtree(int n_, Info v_ = Info())
        : LazySegtree(n_, std::vector(n_, v_)) {}

    template <class T>
    explicit LazySegtree(int n_, std::vector<T> a_) : n(n_) {
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
            modify(ml, mr, t, id * 2, l, m);
            modify(ml, mr, t, id * 2 + 1, m + 1, r);
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
        int res = find_first(ql, qr, id * 2 + 1, m + 1, r, pred);
        if (res == -1) {
            res = find_first(ql, qr, id * 2, l, m, pred);
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
        apply(id * 2, tag);
        apply(id * 2 + 1, tag);
        tag[id] = Tag();
    }
};

struct Tag {
    void apply(const Tag &t) {}
};

struct Info {
    int x;

    friend Info operator+(const Info &lhs, const Info &rhs) {
        return lhs + rhs;
    }
    void apply(const Tag &t) {}
};
  ]], {}, { delimiters = "@$" })),
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
}


--snippet qpow quick pow
--    ll qpow(ll a, ll b) {
--        ll res = 1;
--        while (b) {
--            if (b & 1) {
--                res = res * a;
--            }
--            a = a * a;
--            b >>= 1;
--        }
--        return res;
--    }
--
--
--snippet qpowp quick pow with p
--    ll qpow(ll a, ll b, ll p) {
--        ll res = 1;
--        while (b) {
--            if (b & 1) {
--                res = res * a % p;
--            }
--            a = a * a % p;
--            b >>= 1;
--        }
--        return res;
--    }
--
--snippet qpownop quick pow without p
--    ll qpow(ll a, ll b) {
--        ll res = 1;
--        while (b) {
--            if (b & 1) {
--                res = res * a;
--            }
--            a = a * a;
--            b >>= 1;
--        }
--        return res;
--    }
--
--snippet exgcd extended gcd
--    ll exgcd(ll a, ll b, ll &x, ll &y) {
--        if (!b) {
--            x = 1;
--            y = 0;
--            return a;
--        }
--        ll d = exgcd(b, a % b, y, x);
--        y -= a / b * x;
--        return d;
--    }
--
--snippet exgcdp extended gcd with p
--    ll exgcd (ll a, ll b, ll &x, ll &y, ll p) {
--        if (!b) {
--            x = 1;
--            y = 0;
--            return a;
--        }
--        ll d = exgcd(b, a % b, y, x, p);
--        y -= a / b * x;
--        return d;
--    }
