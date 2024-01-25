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
        return 0;
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
        return 0;
    }
  ]], { i(1) }, { delimiters = "@$" })),

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

  s("directed_graph", fmta([[
template <typename T>
struct Graph {
    int N;
    std::vector<std::vector<T>> adj;
    Graph(T n) : N(n), adj(n + 1) {}
    void add_edge(T u, T v) { adj[u].emplace_back(v); }
};
  ]], {}, { delimiters = "@$" })),

  s("ordered_edges", fmta([[
template <typename T>
struct OEdges {
    int W;
    std::vector<std::vector<PII>> edges;
    OEdges(T maxWeight) : W(maxWeight), edges(maxWeight + 1) {}
    void add_edge(T weight, int u, int v) { edges[weight].push_back({u, v}); }
};
  ]], {}, { delimiters = "@$" })),

  s("dsu", fmta([[
template <typename T>
struct Dsu {
    std::vector<T> p;
    Dsu(T n) : p(n + 1, -1) {}
    T root(T x) { return p[x] < 0 ? x : p[x] = root(p[x]); }
    bool merge(T x, T y) {
        x = root(x), y = root(y);
        if (x == y) {
            return false;
        }
        // size_y > size_x
        if (p[x] > p[y]) {
            std::swap(x, y);
        }
        // merge y to x
        p[x] += p[y];
        p[y] = x;
        return true;
    }
    bool same(T x, T y) { return root(x) == root(y); }
    T size(T x) { return -p[root(x)]; }
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
    Mint(ll _x) : x(_x % mod) {
        if (x < 0) {
            x += mod;
        }
    }
    Mint() = default;
    Mint operator-() { return Mint(-x); }
    Mint operator+() { return Mint(x); }
    Mint &operator+=(const Mint &rhs) {
        if ((x += rhs.x) >= mod) {
            x -= mod;
        }
        return *this;
    }
    Mint &operator-=(const Mint &rhs) {
        x -= rhs.x;
        if (x < 0) {
            x += mod;
        }
        return *this;
    }
    Mint &operator*=(const Mint &rhs) {
        x = x * rhs.x % mod;
        if (x < 0) {
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
        (x *= rhs) %= mod;
        return *this;
    }
    Mint &operator/=(const Mint &rhs) { return *this *= rhs.inv(); }

    // the same as std::vector v2(v1)
    Mint operator+(const Mint rhs) { return Mint(*this) += rhs; }
    Mint operator-(const Mint rhs) { return Mint(*this) -= rhs; }
    Mint operator*(const Mint rhs) { return Mint(*this) *= rhs; }
    Mint operator/(const Mint rhs) { return Mint(*this) /= rhs; }
    Mint operator+(const ll rhs) { return Mint(*this) += rhs; }
    Mint operator-(const ll rhs) { return Mint(*this) -= rhs; }
    Mint operator*(const ll rhs) { return Mint(*this) *= rhs; }
    Mint operator/(const ll rhs) { return Mint(*this) / Mint(rhs); }
    bool operator>(const ll rhs) { return x > rhs; }
    bool operator<(const ll rhs) { return x < rhs; }
    bool operator==(const ll rhs) { return x == rhs; }
    bool operator!=(const ll rhs) { return x != rhs; }
    bool operator>(const Mint rhs) { return x > rhs.x; }
    bool operator<(const Mint rhs) { return x < rhs.x; }
    bool operator==(const Mint rhs) { return x == rhs.x; }
    bool operator!=(const Mint rhs) { return x != rhs.x; }

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
}


--snippet qmi quick pow
--    ll qmi(ll a, ll b) {
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
--snippet qmip quick pow with p
--    ll qmi(ll a, ll b, ll p) {
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
--snippet qminop quick pow without p
--    ll qmi(ll a, ll b) {
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
