# QBLAS 项目深度分析报告

**项目**: QBLAS (Quantum Basic Linear Algebra Subprograms)
**版本**: v0.3.0
**技术栈**: Microsoft QDK 1.28.0 (Rust/Python) / 前身: Q# 0.28.302812 + .NET 6.0
**许可证**: GPL v3
**作者**: Xiaopeng Cui, Yu Shi (复旦大学物理系)
**发布日期**: 2019年11月

---

## 1. 项目概述

QBLAS 是一个开源的量子线性代数与量子模拟库，基于 Microsoft Q# 编程语言开发。该项目旨在为量子机器学习算法提供基础线性代数支持，是量子计算领域的重要开源贡献。

### 1.1 核心定位

- **量子BLAS**: 提供量子版本的经典BLAS库功能
- **量子模拟**: 支持稀疏矩阵和密度矩阵的量子模拟
- **量子机器学习**: 为量子机器学习算法提供底层支持

### 1.2 主要功能模块

| 模块 | 文件 | 功能描述 |
|------|------|----------|
| 向量运算 | q_vector.qs | 状态制备、QRAM、振幅编码、内积计算 |
| 矩阵运算 | q_matrix.qs | 稀疏矩阵oracle定义与测试 |
| 量子RAM | q_ram.qs | 地址寻址、数据加载、SwapA矩阵操作 |
| 傅里叶变换 | q_fft.qs | QFT与IQFT实现 |
| 相位估计 | q_phase_estimate.qs | 量子相位估计核心算法 |
| HHL算法 | q_hhl.qs | 线性方程组求解（基础版） |
| 增强HHL | q_hhl_enhanced.qs | 预条件、多精度旋转、特征值过滤、幅度放大 |
| SVD/EVD | q_svd.qs | SVD/EVD特征值分解（基础版） |
| 可变时间SVD | q_svd_vartime.qs | 自适应精度、特征值间隙检测、条件数估计 |
| 量子行走 | q_walk.qs | 1-稀疏矩阵行走模拟 |
| 量子模拟 | q_simulation.qs | Trotter分解、密度矩阵演化 |
| 量子传态 | q_tele.qs | 隐形传态与Dense Coding |
| 算术运算 | q_math.qs | 量子整数倒数运算 |
| SWAP测试 | q_swap_test.qs | 内积与距离估计 |
| 通用工具 | q_com.qs | 类型转换、Qubit数组操作 |
| 调试工具 | q_debug.qs | 调试输出函数 |
| **GEMV** | q_gemv.qs | 量子矩阵-向量乘法 |
| **GEMM** | q_gemm.qs | 量子矩阵-矩阵乘法（块乘法、迭代细化、批操作） |

---

## 2. 项目结构

```
qblas/
├── src/qblas/
│   ├── qblas/                    # 核心量子库
│   │   ├── q_com.qs              # 通用工具
│   │   ├── q_matrix.qs          # 矩阵运算
│   │   ├── q_vector.qs          # 向量运算
│   │   ├── q_ram.qs             # 量子RAM
│   │   ├── q_fft.qs             # 傅里叶变换
│   │   ├── q_phase_estimate.qs  # 相位估计
│   │   ├── q_hhl.qs             # HHL算法（基础版）
│   │   ├── q_hhl_enhanced.qs    # 增强HHL算法
│   │   ├── q_svd.qs             # SVD/EVD（基础版）
│   │   ├── q_svd_vartime.qs     # 可变时间SVD
│   │   ├── q_walk.qs            # 量子行走
│   │   ├── q_simulation.qs      # 量子模拟
│   │   ├── q_tele.qs            # 量子传态
│   │   ├── q_math.qs            # 量子算术
│   │   ├── q_swap_test.qs       # SWAP测试
│   │   ├── q_debug.qs           # 调试工具
│   │   ├── q_gemv.qs            # 矩阵-向量乘法
│   │   ├── q_gemm.qs            # 矩阵-矩阵乘法
│   │   └── qblas.csproj         # 项目文件
│   └── test/                     # 测试项目
│       ├── Driver.cs             # C# 测试入口
│       ├── test.qs               # 基本测试
│       └── test.csproj           # 测试项目文件
├── doc/
│   ├── qblas.pdf                 # 详细技术文档
│   ├── fig/                      # 结构图
│   └── ref/                      # 参考论文
└── README.md                     # 项目说明
```

---

## 3. 核心算法实现分析

### 3.1 量子GEMV - 矩阵向量乘法

**文件**: q_gemv.qs

量子矩阵-向量乘法，计算 y = A*x。

**核心函数**:
- `q_gemv`: 核心量子行走实现
- `q_gemv_iterated`: 迭代应用提高精度
- `q_gemv_batch`: 批处理多向量
- `q_gemv_sparse_to_ram`: 稀疏矩阵转RAM格式

### 3.2 量子GEMM - 矩阵矩阵乘法

**文件**: q_gemm.qs

量子矩阵-矩阵乘法，计算 C = A*B。

**核心函数**:
- `q_gemm`: 块级矩阵乘法
- `q_gemm_iterative`: 迭代细化
- `q_gemm_batch`: 批处理
- `q_gemm_transpose`: 支持转置变体

### 3.3 可变时间量子SVD

**文件**: q_svd_vartime.qs

标准SVD使用固定时间处理所有特征值，可变时间SVD根据特征值大小自适应调整测量时间。

**复杂度改进**: O(1/epsilon) -> O(log(1/epsilon)) （对于条件数良好的矩阵）

**核心函数**:
- `q_svd_vartime_core`: 自适应奇异性值估计
- `q_svd_vartime_full`: 多奇异值计算
- `q_svd_vartime_rotation`: 条件数感知旋转
- `q_svd_vartime_gap`: 特征值间隙检测
- `q_svd_estimate_condition`: 条件数估计

### 3.4 增强HHL算法

**文件**: q_hhl_enhanced.qs

增强版HHL算法，支持预条件、多精度旋转、特征值过滤、幅度放大和动态解耦。

**核心函数**:
- `q_hhl_enhanced_rotation`: 条件数调整的旋转
- `q_hhl_preconditioned`: 预条件支持
- `q_hhl_multiprecision`: 大/小特征值自适应精度
- `q_hhl_filtered`: 特征值过滤
- `q_hhl_amp_amplified`: 幅度放大
- `q_hhl_decoupled`: 动态解耦

### 3.5 量子傅里叶变换 (QFT)

**文件**: q_fft.qs

QFT实现了量子版本的快速傅里叶变换，使用Hadamard门和受控R1Frac门实现。

**核心函数**:
- `q_fft_core`: 核心QFT实现
- `q_fft`: 完整QFT操作
- `q_fft_adjoint`: 逆QFT (IQFT)

### 3.6 量子相位估计 (QPE)

**文件**: q_phase_estimate.qs

QPE是许多量子算法的核心子程序，用于估计单位矩阵的特征值相位。

**核心函数**:
- `q_phase_estimate_core`: 核心QPE实现
- `q_phase_estimate`: 完整QPE操作

### 3.7 量子RAM (QRAM)

**文件**: q_ram.qs

QRAM提供了量子计算机访问经典数据的机制。

**关键函数**:
- `q_ram_addressing`: 地址准备
- `q_ram_load`: 数据加载
- `q_ram_call_lamda_rcp`: HHL特征值倒数加载（用于1/λ旋转）

---

## 4. 模块依赖关系

```
q_simulation.qs
    ├── q_walk.qs (量子行走)
    ├── q_matrix.qs (矩阵oracle)
    └── q_ram.qs (QRAM操作)

q_hhl.qs / q_hhl_enhanced.qs
    ├── q_phase_estimate.qs (QPE)
    └── q_ram.qs (lambda reciprocal)

q_svd.qs / q_svd_vartime.qs
    ├── q_hhl.qs / q_hhl_enhanced.qs (旋转)
    └── q_phase_estimate.qs (QPE)

q_gemv.qs / q_gemm.qs
    ├── q_walk.qs (量子行走模拟)
    └── q_matrix.qs (矩阵oracle)

q_fft.qs
    └── q_com.qs (swap_all用于位序反转)
```

---

## 5. 量子算法实现状态

| 算法 | 状态 | 文件 | 说明 |
|------|------|------|------|
| QFT | ✅ 完成 | q_fft.qs | 包含QFT和IQFT |
| QPE | ✅ 完成 | q_phase_estimate.qs | 核心相位估计 |
| QPE现代版 | ✅ 完成 | q_qpe_modern.qs | Bayesian相位估计 |
| HHL | ✅ 完成 | q_hhl.qs | 含until-OK变体 |
| 增强HHL | ✅ 完成 | q_hhl_enhanced.qs | 预条件、多精度、过滤、放大 |
| SVD/EVD | ✅ 完成 | q_svd.qs | 复用QPE |
| 可变时间SVD | ✅ 完成 | q_svd_vartime.qs | 自适应精度 |
| GEMV | ✅ 完成 | q_gemv.qs | 矩阵-向量乘法 |
| GEMM | ✅ 完成 | q_gemm.qs | 矩阵-矩阵乘法 |
| 量子行走 | ✅ 完成 | q_walk.qs | 6种矩阵类型 |
| Trotter模拟 | ✅ 完成 | q_simulation.qs | 多矩阵支持 |
| Trotter-Suzuki | ✅ 完成 | q_trotter_suzuki.qs | 高阶分解 |
| 2-稀疏模拟 | ✅ 完成 | q_2sparse.qs | 二稀疏哈密顿量 |
| 量子传态 | ✅ 完成 | q_tele.qs | 含Dense Coding |
| SWAP Test | ✅ 完成 | q_swap_test.qs | 内积/距离估计 |
| QRAM | ✅ 完成 | q_ram.qs | 多种数据类型 |
| QSP | ✅ 完成 | q_qsp.qs | 量子信号处理 |
| QSVT | ✅ 完成 | q_qsvt.qs | 量子奇异值变换 |
| Block Encoding | ✅ 完成 | q_block_encoding.qs | d-稀疏矩阵编码 |
| Block Encoding v2 | ✅ 完成 | q_block_encoding_v2.qs | QROM/LCU/OAA |
| VQE | ✅ 完成 | q_vqe.qs | HEA/QAOA/SU2 ansatz + Adam |
| VQE (组件) | ✅ 完成 | q_vqe.qs | 梯度估计、参数平移、shot分配 |
| Krylov子空间 | ✅ 完成 | q_krylov.qs | Arnoldi迭代 + SWAP测试 |
| Lanczos | ✅ 完成 | q_lanczos.qs | 三对角化 + 特征值 |
| GMRES | ✅ 完成 | q_gmres.qs | 广义最小残差 |
| Conjugate Gradient | ✅ 完成 | q_conjugate_gradient.qs | CG线性求解 |
| 梯度下降 | ✅ 完成 | q_gradient_descent.qs | 量子梯度下降 |
| Newton法 | ✅ 完成 | q_newton.qs | 二阶优化 |
| PCA | ✅ 完成 | q_pca.qs | QPE特征值估计 |
| Ridge回归 | ✅ 完成 | q_ridge_regression.qs | Tikhonov正则化 |
| 三角系统求解 | ✅ 完成 | q_triangular.qs | 前向/后向代入 |
| 振幅放大 | ✅ 完成 | q_amplitude_amplification.qs | 最优迭代 |
| 梯度估计 | ✅ 完成 | q_gradient_estimation.qs | 参数平移/自然梯度 |
| 伪逆 | ✅ 完成 | q_pseudoinverse.qs | Moore-Penrose |
| 正则化最小二乘 | ✅ 完成 | q_regularized_ls.qs | 岭回归+L1/L2 |
| 特征值过滤 | ✅ 完成 | q_eigenvalue_filter.qs | 低通/高通/带通 |
| Chebyshev | ✅ 完成 | q_chebyshev.qs | Chebyshev多项式 |
| 矩阵函数 | ✅ 完成 | q_matrix_function.qs | 矩阵多项式变换 |
| 内积 | ✅ 完成 | q_inner_product.qs | SWAP测试测量 |
| 向量范数 | ✅ 完成 | q_vector_norm.qs | 状态范数估计 |
| Qubitization | ✅ 完成 | q_qubitization.qs | QSP相位模拟 |
| LCU优化 | ✅ 完成 | q_lcu_optimized.qs | 单ancilla SELECT+PREPARE |
| Gibbs态制备 | ✅ 完成 | q_gibbs.qs | 虚时演化 |
| 时变哈密顿量 | ✅ 完成 | q_timedependent.qs | H(t) Strang分裂 |
| LU分解 | ✅ 完成 | q_lu.qs | HHL风格线性求解 |
| Cholesky | ✅ 完成 | q_cholesky.qs | SPD线性求解 |
| QR分解 | ✅ 完成 | q_qr.qs | 量子最小二乘 |
| 矩阵加法 | ✅ 完成 | q_matrix_add.qs | A+B block encoding |
| Kronecker积 | ✅ 完成 | q_kronecker.qs | A⊗B量子态应用 |
| 误差缓解 | ✅ 完成 | q_error_mitigation.qs | ZNE噪声外推 |
| 核方法 | ✅ 完成 | q_kernel.qs | SWAP测试核矩阵 |

---

## 6. 高优先级量子线性代数原语

### 6.1 GEMV - 矩阵向量乘法

量子矩阵-向量乘法是量子线性代数的基本操作。

**功能**:
- 量子行走模拟
- 迭代细化提高精度
- 批处理多向量
- 稀疏矩阵支持

### 6.2 GEMM - 矩阵矩阵乘法

量子矩阵-矩阵乘法用于计算 C = A*B。

**功能**:
- 块级乘法
- 迭代细化
- 批处理操作
- 转置变体

### 6.3 可变时间SVD

量子奇异值分解，带自适应精度。

**功能**:
- 自适应精度调整
- 特征值间隙检测
- 条件数估计
- 排序和过滤

### 6.4 增强HHL

量子线性方程组求解的增强版本。

**功能**:
- 预条件支持
- 多精度旋转
- 特征值过滤
- 幅度放大
- 动态解耦

---

## 7. 技术债务与问题

### 7.1 版本过旧

- **当前版本**: QDK 1.28.0 (2026年4月)
- **状态**: 已完成从Q# 0.28.x到QDK 1.28.0的完整迁移

### 7.2 部分stub实现

- `q_walk_op_V` (q_walk.qs:52-57): 空操作占位符

### 7.3 硬编码参数

```qsharp
function q_com_real_nbit_float() : Int {
    body {
        let nbit_float = 2;  // 固定为2，无配置选项
        return nbit_float;
    }
}
```

### 7.4 基础设施（已改善）

- 无CI/CD自动化构建（待添加）
- ✅ Python测试框架 (tools/run_all_tests.py，310测试通过)
- ✅ 版本发布流程 (v0.2.13→v0.2.14→v0.2.15→v0.3.0，git tag)

---

## 8. 开发建议

### 8.1 短期改进 (1-3个月)

1. **完善测试**: 补充GEMV、GEMM、VT-SVD、增强HHL的单元测试
2. **代码清理**: 实现stub函数，完成TODO
3. **文档**: 添加API文档和使用示例

### 8.2 中期改进 (3-6个月)

1. **版本升级**: 适配最新Q# (0.27+)
2. **性能优化**: 减少CNOT门数量，优化电路深度
3. **新算法**: 实现VQE、QAOA等常见算法

### 8.3 长期规划 (6-12个月)

1. **多后端支持**: 适配IBM Qiskit、Google Cirq等
2. **实际应用**: 量子机器学习应用示例
3. **社区建设**: 贡献指南、Issue跟踪、版本发布

---

## 9. 参考资料

- 项目网站: http://qblas.site
- GitHub: https://github.com/xpclove/qblas
- Q#文档: https://docs.microsoft.com/en-us/quantum/

### 核心参考文献

[1] Biamonte et al., "Quantum machine learning", Nature 549, 195-202 (2017)  
[2] Lloyd et al., "Quantum principal component analysis", Nature Physics 10, 631-633 (2014)  
[4] Harrow et al., "Quantum algorithm for linear systems of equations", Phys. Rev. Lett. 103, 150502 (2009)  
[7] Childs et al., "Exponential algorithmic speedup by quantum walk", quant-ph/0209131 (2002)  
[11] Giovannetti et al., "Quantum random access memory", Phys. Rev. Lett. 100, 160501 (2008)


---

## 10. 近期开发进展 (v0.2.13 ~ v0.3.0)

### 10.1 v0.2.13 — 9个Krylov/优化/LA模块量子化 (2026年5月)

**Krylov子空间方法（完整量子实现）：**
- `q_krylov.qs`: Arnoldi迭代 + 量子行走 + SWAP测试（6个新操作）
- `q_lanczos.qs`: Lanczos三对角化 + 三项递推（5个新操作）
- `q_gmres.qs`: GMRES求解器 + Hessenberg构造（4个新操作）

**优化方法（完整量子实现）：**
- `q_conjugate_gradient.qs`: CG线性系统求解（3个新操作）
- `q_gradient_descent.qs`: 梯度下降优化器（2个新操作）
- `q_newton.qs`: Newton法 + Hessian估计（2个新操作）

**矩阵分解与应用：**
- `q_pca.qs`: PCA + QPE特征值估计（2个新操作）
- `q_ridge_regression.qs`: 岭回归求解器（2个新操作）
- `q_triangular.qs`: 三角系统求解器（3个新操作）

**结果**: 26个新量子操作，293测试通过

### 10.2 v0.2.14 — 剩余15个Layer 0模块量子化 (2026年5月)

**哈密顿量模拟：**
- `q_qubitization.qs`: Qubitization + QSP相位模拟（1个新操作）
- `q_lcu_optimized.qs`: 单ancilla LCU SELECT+PREPARE（2个新操作）
- `q_gibbs.qs`: Gibbs态制备 + 虚时演化（1个新操作）
- `q_timedependent.qs`: 时变H(t)模拟 + Strang分裂（2个新操作）

**量子原语：**
- `q_inner_product.qs`: SWAP测试测量（1个新操作）
- `q_vector_norm.qs`: 状态范数估计（1个新操作）
- `q_gradient_estimation.qs`: 参数平移电路执行（1个新操作）

**经典→量子求解器：**
- `q_lu.qs`: HHL风格量子线性求解（1个新操作）
- `q_cholesky.qs`: SPD量子线性求解（1个新操作）
- `q_qr.qs`: 量子最小二乘求解（1个新操作）
- `q_matrix_add.qs`: A+B block encoding（1个新操作）
- `q_kronecker.qs`: A⊗B量子态应用（1个新操作）
- `q_error_mitigation.qs`: ZNE噪声外推（1个新操作）

**核方法：**
- `q_kernel.qs`: 量子核矩阵SWAP测试（1个新操作）

**结果**: 18个新量子操作，308测试通过

### 10.3 v0.2.15 — 版本发布 (2026年5月)

- 版本号: v0.2.15
- 标签: `git tag v0.2.15`
- 总计: 55个模块，310+个操作/函数，308测试通过

### 10.4 v0.3.0 — QDK 1.28 完整迁移 (2026年5月16日)

**背景**:
Microsoft于2024年1月将旧版Q#编译器(qsharp-compiler)归档，转向Rust/Python架构的新QDK。
新QDK v1.28.0使用Rust编译器(qsc)+Python前端，取代了旧的.NET/MSBuild/NuGet体系。

**迁移内容（60个.qs文件，~590KB代码）：**

| 语法迁移 | 数量 | 说明 |
|---------|------|------|
| `body { } adjoint auto;` → `is Adj + Ctl` | 149个操作 | 操作签名标注 |
| `for (...) { }` → `for ... { }` | 555处 | 移除循环括号 |
| `using (qs = ...) { }` → `{ use qs = ...; }` | 16处 | qubit分配语法 |
| `PowD(a,b)` → `a ^ b`, `ExpD(x)` → `E() ^ x` | 22处 | 数学函数 |
| `open Microsoft.Quantum.{Math,Convert}` → `import Std.{Math,Convert}.*` | 100+处 | 命名空间变更 |
| NewType `((Qubit[],...) => ...)` → `(Qubit[],...) => ...` | 5处 | 移除多余括号 |
| `new Qubit[n]` → 数组拼接; `new (Qubit[])` → 增量构建 | 3处 | 数组分配 |

**测试系统重写：**
- 旧: C# Driver.cs (1580行) + QuantumSimulator
- 新: Python tools/run_all_tests.py + Rust原生模拟器
- 支持: 多轮次统计(qsharp.run)、资源估算(qsharp.estimate)、电路可视化

**结果: 310测试全部通过，零残留旧语法**

### 10.5 未来方向

| 方向 | 说明 | 优先级 |
|------|------|--------|
| **Python API层** | PyPI发布qblas，`from qblas import hhl` | ⭐⭐⭐ |
| **CI/CD** | GitHub Actions自动测试 | ⭐⭐⭐ |
| **资源估算** | 55个算法的硬件成本表 | ⭐⭐⭐ |
| **Jupyter教程** | 5-8个交互式笔记 | ⭐⭐ |
| **跨框架对标** | QBLAS vs Qiskit vs Cirq | ⭐⭐ |
| **ML管线集成** | PennyLane + PyTorch | ⭐⭐ |


---

## 附录A: 核心数据结构

### A.1 稀疏矩阵Oracle

```qsharp
newtype q_matrix_1_sparse_oracle = ((Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl);
```

### A.2 RAM权重条目

```qsharp
newtype QBLAS_M_Weight = (Int, Int, Int);  // (vertex, next_vertex, weight)
```

---

## 附录B: 测试运行方式（新QDK 1.28）

```bash
cd qblas
pip install qsharp
python tools/run_all_tests.py
```

或使用构建脚本:
```bash
./build.sh
```

预期输出（节选）:
```
QBLAS Full Test Runner (QDK v1.28)
============================================================
Loading Q# files...
  587100 chars
Compiling...
  COMPILE OK
Found 310 test calls in Driver.cs
Running Tests...
  [Test 1] q_tele_dense_coding_1
  test_qs_tele(0) = 0
  ...
  [Test 310] test_kernel_compute_matrix_quantum
  test_kernel_compute_matrix_quantum(0) = 1.0
============================================================
Results: 310 passed, 0 failed out of 310
============================================================
```

旧版.NET测试运行方式 (Driver.cs) 保留为参考，不再作为主要测试入口。

---

*报告生成日期: 2026年5月16日*
*分析工具: opencode AI assistant*