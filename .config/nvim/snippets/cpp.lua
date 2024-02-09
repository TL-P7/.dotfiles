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

  s("modint", fmt([[

constexpr int mod = @$;
struct Mint {
public:
    explicit Mint(ll _x) : x(_x % mod) {
        if (x < 0) {
            x += mod;
        }
    }
    explicit Mint() : x(0) {}
    Mint operator-() { return Mint(-x); }
    Mint operator+() { return Mint(x); }
    Mint &operator++() {
        if ((x += 1) == mod) {
            x = 0;
        }
        return *this;
    }
    Mint operator++(int) {
        Mint pmt = *this;
        ++*this;
        return pmt;
    }
    Mint &operator--() {
        if ((x -= 1) < 0) {
            x += mod;
        }
        return *this;
    }
    Mint operator--(int) {
        Mint pmt = *this;
        --*this;
        return pmt;
    }
    Mint &operator+=(const Mint &rhs) {
        if ((x += rhs.x) >= mod) {
            x -= mod;
        }
        return *this;
    }
    Mint &operator-=(const Mint &rhs) {
        if ((x -= rhs.x) < 0) {
            x += mod;
        }
        return *this;
    }
    Mint &operator*=(const Mint &rhs) {
        if ((x = x * rhs.x % mod) < 0) {
            x += mod;
        }
        return *this;
    }
    Mint &operator+=(const ll &rhs) {
        if ((x += rhs) >= mod) {
            x -= mod;
        }
        return *this;
    }
    Mint &operator-=(const ll rhs) {
        if ((x += (mod - rhs)) >= mod) {
            x -= mod;
        }
        return *this;
    }
    Mint &operator*=(const ll rhs) {
        if ((x = x * rhs % mod) < 0) {
            x += mod;
        }
        return *this;
    }
    Mint &operator/=(const Mint &rhs) { return *this *= rhs.inv(); }

    Mint &operator=(const ll rhs) {
        *this = Mint(rhs);
        return *this;
    }

    // the same as std::vector v2(v1)
    Mint operator+(const Mint rhs) const { return Mint(*this) += rhs; }
    Mint operator-(const Mint rhs) const { return Mint(*this) -= rhs; }
    Mint operator*(const Mint rhs) const { return Mint(*this) *= rhs; }
    Mint operator/(const Mint rhs) const { return Mint(*this) /= rhs; }
    Mint operator+(const ll rhs) const { return Mint(*this) += rhs; }
    Mint operator-(const ll rhs) const { return Mint(*this) -= rhs; }
    Mint operator*(const ll rhs) const { return Mint(*this) *= rhs; }
    Mint operator/(const ll rhs) const { return Mint(*this) / Mint(rhs); }
    bool operator>(const ll rhs) const { return x > rhs; }
    bool operator>=(const ll rhs) const { return x >= rhs; }
    bool operator<(const ll rhs) const { return x < rhs; }
    bool operator<=(const ll rhs) const { return x <= rhs; }
    bool operator==(const ll rhs) const { return x == rhs; }
    bool operator!=(const ll rhs) const { return x != rhs; }
    bool operator>(const Mint rhs) const { return x > rhs.x; }
    bool operator>=(const Mint rhs) const { return x >= rhs.x; }
    bool operator<(const Mint rhs) const { return x < rhs.x; }
    bool operator<=(const Mint rhs) const { return x <= rhs.x; }
    bool operator==(const Mint rhs) const { return x == rhs.x; }
    bool operator!=(const Mint rhs) const { return x != rhs.x; }

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

    // Mint inv() const { return this->pow(mod - 2); }
    Mint inv() const {
        ll a = x, b = mod, u = 1, v = 0;
        while (b) {
            ll t = a / b;
            a -= t * b, std::swap(a, b);
            u -= t * v, std::swap(u, v);
        }
        return Mint(u);
    }
    friend std::istream &operator>>(std::istream &is, Mint &mint) {
        is >> mint.x;
        mint.x %= mod;
        if (mint.x < 0) {
            mint.x += mod;
        }
        return is;
    }
    friend std::ostream &operator<<(std::ostream &os, const Mint &mint) {
        return os << mint.x;
    }

private:
    ll x;
};
]], { i(1, "998244353") }, { delimiters = "@$" })),

  s("rw", fmt([[
template <typename T>
T read() {
    T x = 0;
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

template <typename T>
void write(T x) {
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
template <class T = ll>
struct FenwickTree {
    FenwickTree() : n(0) {}
    explicit FenwickTree(int _n) : n(_n), data(n + 1) {}

    void add(int p, T x) {
        while (p <= n) {
            data[p] += x;
            p += p & -p;
        }
    }
    T sum(int l, int r) { return sum(r) - sum(l - 1); }
    int query(T x) {
        int pos = 0, l = 1;
        while (1 << l <= n) {
            l++;
        }
        for (int i = l - 1; i >= 0; i--) {
            int j = 1 << i;
            // rightmost
            if (pos + j <= n && data[pos + j] <= x) {
                pos += j;
                x -= data[pos];
            }
        }
        return pos;
    }


private:
    int n;
    std::vector<T> data;

    T sum(int p) {
        T s = 0;
        while (p) {
            s += data[p];
            p -= p & -p;
        }
        return s;
    }
};
  ]], {}, { delimiters = "@$" })),

  s("segtree", fmt([[
template <class T>
struct Segtree {
    Segtree() : n(0) {}
    explicit Segtree(int _n) : n(_n) {
        size = bit_ceil(n);
        log = __builtin_ctz(size);
        d = std::vector<T>(size * 2);
    }
    // one-base
    explicit Segtree(int _n, std::vector<T> &a) : n(_n) {
        size = bit_ceil(n);
        log = __builtin_ctz(size);
        d = std::vector<T>(size * 2);
        build(a);
    }

    void build(std::vector<T> &a) { build(a, 1, 1, n); }
    void build(std::vector<T> &a, int id, int l, int r) {
        if (l == r) {
            d[id] = a[l];
            return;
        }
        int m = (l + r) / 2;
        build(a, id * 2, l, m);
        build(a, id * 2 + 1, m + 1, r);
        update(id);
    }
    void set(int p, T val) { set(p, val, 1, 1, n); }
    void set(int p, T val, int id, int l, int r) {
        if (l == r) {
            d[id] = val;
            return;
        }
        int m = (l + r) / 2;
        if (p <= m) {
            set(p, val, id * 2, l, m);
        } else {
            set(p, val, id * 2 + 1, m + 1, r);
        }
        update(id);
    }
    T query(int ql, int qr) const { return query(ql, qr, 1, 1, n); }
    T query(int ql, int qr, int id, int l, int r) const {
        if (l == ql && r == qr) {
            return d[id];
        }
        int m = (l + r) / 2;
        if (qr <= m) {
            return query(ql, qr, id * 2, l, m);
        } else if (ql > m) {
            return query(ql, qr, id * 2 + 1, m + 1, r);
        } else {
            return op(query(ql, m, id * 2, l, m),
                      query(m + 1, qr, id * 2 + 1, m + 1, r));
        }
    }

private:
    int n, size, log;
    std::vector<T> d;
    unsigned int bit_ceil(unsigned int n) {
        unsigned int x = 1;
        while (x < (unsigned int)(n)) {
            x *= 2;
        }
        return x;
    }
    void update(int p) { d[p] = op(d[p * 2], d[p * 2 + 1]); }
    T op(T lhs, T rhs) const { return lhs + rhs; }
};
  ]], {}, { delimiters = "@$" })),

  s("lazy_segtree", fmt([[
template <class T, class S>
struct LazySegtree {
    LazySegtree() : n(0) {}
    explicit LazySegtree(int _n) : n(_n) {
        size = bit_ceil(n);
        log = __builtin_ctz(size);
        d = std::vector<T>(size * 2);
        sz = std::vector<int>(size * 2);
        lz = std::vector<S>(size * 2);
    }
    // one-base
    explicit LazySegtree(int _n, std::vector<T> &a) : n(_n) {
        size = bit_ceil(n);
        log = __builtin_ctz(size);
        d = std::vector<T>(size * 2);
        sz = std::vector<int>(size * 2);
        lz = std::vector<S>(size * 2);
        build(a);
    }

    void build(std::vector<T> &a) { build(a, 1, 1, n); }
    void build(std::vector<T> &a, int id, int l, int r) {
        sz[id] = r - l + 1;
        if (l == r) {
            d[id] = a[l];
            return;
        }
        int m = (l + r) / 2;
        build(a, id * 2, l, m);
        build(a, id * 2 + 1, m + 1, r);
        update(id);
    }

    void set(int p, T val) { set(p, val, 1, 1, n); }
    void set(int p, T val, int id, int l, int r) {
        if (l == r) {
            d[id] = val;
            return;
        }
        int m = (l + r) / 2;
        if (p <= m) {
            set(p, val, id * 2, l, m);
        } else {
            set(p, val, id * 2 + 1, m + 1, r);
        }
        update(id);
    }

    void modify(int ml, int mr, S x) { modify(ml, mr, x, 1, 1, n); }
    void modify(int ml, int mr, S x, int id, int l, int r) {
        if (l == ml && r == mr) {
            apply(id, x);
            return;
        }
        push(id);
        int m = (l + r) / 2;
        if (mr <= m) {
            modify(ml, mr, x, id * 2, l, m);
        } else if (ml > m) {
            modify(ml, mr, x, id * 2 + 1, m + 1, r);
        } else {
            modify(ml, m, x, id * 2, l, m);
            modify(m + 1, mr, x, id * 2 + 1, m + 1, r);
        }
        update(id);
    }

    T query(int ql, int qr) { return query(ql, qr, 1, 1, n); }
    T query(int ql, int qr, int id, int l, int r) {
        if (l == ql && r == qr) {
            return d[id];
        }
        push(id);
        int m = (l + r) / 2;
        if (qr <= m) {
            return query(ql, qr, id * 2, l, m);
        } else if (ql > m) {
            return query(ql, qr, id * 2 + 1, m + 1, r);
        } else {
            return op(query(ql, m, id * 2, l, m),
                      query(m + 1, qr, id * 2 + 1, m + 1, r));
        }
    }

private:
    int n, size, log;
    std::vector<T> d;
    std::vector<int> sz;
    std::vector<S> lz;
    unsigned int bit_ceil(unsigned int n) {
        unsigned int x = 1;
        while (x < (unsigned int)(n)) {
            x *= 2;
        }
        return x;
    }
    void update(int id) { d[id] = op(d[id * 2], d[id * 2 + 1]); }
    T op(T lhs, T rhs) { return lhs + rhs; }

    void apply(int id, S tag) {
        d[id] += tag * sz[id];
        lz[id] += tag;
    }
    void push(int id) {
        if (lz[id]) {
            apply(id * 2, lz[id]);
            apply(id * 2 + 1, lz[id]);
            lz[id] = 0;
        }
    }
};
  ]], {}, { delimiters = "@$" }))

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
