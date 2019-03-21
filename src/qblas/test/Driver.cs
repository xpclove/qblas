using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.Quantum.Primitive;
namespace Quantum.test
{
    class Driver
    {
        static void Main(string[] args)
        {
            test_vector();
            // test_matrix();
        }
        static void test_matrix()
        {
            Console.WriteLine("start test!");
            using (var sim = new QuantumSimulator())
            {
                // sim.OnLog += (msg) => { Console.WriteLine(msg); };
                for(int i = 0; i < 1; i++)
                {
                    // var res = test_qpe.Run(sim,1).Result;
                    // var res = test_hhl.Run(sim,1).Result;
                    var res = test_DM_simulation.Run(sim,1).Result;
                    Console.WriteLine("run over, Result= ");
                    double[] p = q_debug_dump("dump.txt", 0);
                    for( int j=0; j<2; j++ ) { Console.WriteLine(" |"+ j.ToString()+"> "+ p[j].ToString() + " " ); }
                    Console.WriteLine("end test!");
                }
            }

            Console.WriteLine("hello qsharp!");
        }

        static void test_vector()
        {
            Console.WriteLine("start test!");
            using (var sim = new QuantumSimulator())
            {
                // sim.OnLog += (msg) => { Console.WriteLine(msg); };
                for(int i = 0; i < 1; i++)
                {
                    // var res = test_vector_prepare.Run(sim, i).Result;        //测试实数 ram_call方式 向量制备
                    // var res = test_vector_complex_prepare.Run(sim,1).Result; //测试复数 ram_call方式 向量制备
                    // var res = test_vector_inner.Run(sim,1).Result;       //测试两个单位向量内积
                    var res = test_vectors_inner.Run(sim,1).Result;         //测试向量组内积           
                    Console.WriteLine("run over, Result= ");
                    // double[] p = q_debug_dump("dump.txt", 0);
                    // for( int j=0; j<2; j++ ) { Console.WriteLine(" |"+ j.ToString()+"> "+ p[j].ToString() + " " ); }
                    Console.WriteLine("end test!");
                }
            }

            Console.WriteLine("hello qsharp!");
        }

        //dump模拟器量子比特态 方便统计分析指定量子比特状态
        static double[] q_debug_dump(string filename, int seq_i) // filename: 文件名,   seq_i: 第几个量子比特
        {
            StreamReader sr = File.OpenText(filename);
            string line;
            for( int i=0; i<2; i++ ) line = sr.ReadLine(); // dump文件空line, 跳过
            long n_seq = 0;
            double sum_0 = 0.0;
            double sum_1 = 0.0;
            while( (line=sr.ReadLine()) != null)
            {
                string pattern = @"\d+\.*\d*E*\-*\d*";
                line=line.Replace('e','E');
                MatchCollection ms = Regex.Matches( line,pattern );
                long seq = Int64.Parse( ms[0].Value );
                double real=Double.Parse( ms[1].Value );
                double image=Double.Parse( ms[2].Value );
                double p = real*real + image*image;
                //以上为正则表达式解析dump文件,获取每个基矢概率s
                n_seq++;
                if( (seq&(1<<seq_i) ) == 0 )sum_0 += p; //通过"与"操作累加第seq_i个比特0 or 1状态概率
                else sum_1 += p;
            }
            sr.Close();
            double[] result = new double[2] { sum_0, sum_1 };//输出最终结果
            return( result );
        }
    }
}