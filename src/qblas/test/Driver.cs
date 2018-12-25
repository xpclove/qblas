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
            Console.WriteLine("start test!");
            using (var sim = new QuantumSimulator())
            {
                // sim.OnLog += (msg) => { Console.WriteLine(msg); };
                for(int i = 0; i < 1; i++)
                {
                    // var res = test_vector_prepare.Run(sim, i);
                    var res = test_DM_simulation.Run(sim,1).Result;
                    Console.WriteLine("Run over, Result= "+res);
                    double[] p = q_debug_dump("dump.txt", 0);
                    for( int j=0; j<2; j++ ) { Console.WriteLine( j.ToString()+" "+ p[j].ToString() + " " ); }
                    Console.WriteLine("end test!");
                }
            }

            Console.WriteLine("hello qsharp!");
        }
        static double[] q_debug_dump(string filename, int seq_i)
        {
            StreamReader sr = File.OpenText(filename);
            string line;
            for( int i=0; i<2; i++ ) line = sr.ReadLine(); 
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
                if( (seq&(1<<seq_i) ) == 0 )sum_0 += p;
                else sum_1 += p;
            }
            sr.Close();
            double[] result = new double[2] { sum_0, sum_1 };
            return( result );
        }
    }
}