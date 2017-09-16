using System;
using System.IO;
using NUnit.Framework;
using Newtonsoft.Json;

class Program
{
    [Test]
    public void Test()
    {
        var i = new Class1 ();
        var j = new Class2 ();

        Assert.That(i.ToString(), Is.Not.EqualTo(j.ToString()));
    }

    public static void Main(string[] args)
    {
        var i = new Class1 ();
        var j = new Class2 ();

        Console.WriteLine(i.ToString());
        Console.WriteLine(j.ToString());
        Console.WriteLine(JsonConvert.SerializeObject(args));

        Assert.That(i.ToString(), Is.Not.EqualTo(j.ToString()));
    }
}
