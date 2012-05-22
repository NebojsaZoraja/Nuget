using System.Collections.Generic;

namespace NuGet
{
    public interface IDependentsResolver
    {
        IEnumerable<IPackage> GetDependents(IPackage package);
        IEnumerable<IPackage> GetDependents(IPackage package, bool skipFailures);
    }
}
