using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.IO;
using Microsoft.Quantum.Primitive;
namespace Quantum.test
{
    class Driver
    {
        static void Main(string[] args)
        {
            Console.WriteLine("start test!");
            using (var sim = new QuantumSimulator())
            {
                // sim.OnLog += (msg) => { Console.WriteLine(msg); };
                for(int i = 0; i < 1; i++)
                {
                    // var res = test_vector_prepare.Run(sim, i);
                    var res = test_SwapA.Run(sim,1).Result;
                    Console.WriteLine("Result= "+res);
                    Console.WriteLine("end");
                }
            }

            Console.WriteLine("hello qsharp!");
        }
        static double[] q_debug_dump(string filename, int i)
        {
            StreamReader sw = File.OpenText(filename);
            string line;
            for( int i=0; i<2; i++ )
            {
                line = sr.ReadLine();
            }
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
                n_seq++;
                if( (seq&(1<<i) ) == 0 )sum_0 += p;
                else sum_1 += p;
            }
            double[] result = new double[2] { sum_0, sum_1 };
            return( result );
        }
    }
}