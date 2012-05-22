namespace NuGet
{
    using System.Runtime.Versioning;

    public interface IPackageAssemblyReference : IPackageFile
    {
        string Name
        {
            get;
        }
    }
}
