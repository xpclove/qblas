using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
namespace Quantum.test
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                // Try initial values
                Result[] initials = new Result[] { Result.Zero, Result.One };
                foreach (Result initial in initials)
                {
                    var res = test.Run(sim,1.0).Result;
                }
            }

            Console.WriteLine("hello qsharp!");
            Console.ReadKey();
        }
    }
}