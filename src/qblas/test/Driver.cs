using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
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
                // Try initial values
                    Result[] initials = new Result[] { Result.Zero, Result.One };
                //foreach (Result initial in initials)
                //{
                //    var res = test.Run(sim, 1.0);
                //    Console.WriteLine(res.Result);
                //}
                for (int i = 0; i < 8; i++)
                {
                    var res = test_hhl.Run(sim, i);
                    Console.WriteLine(res.Result);
                }

            }

            Console.WriteLine("hello qsharp!");
        }
    }
}