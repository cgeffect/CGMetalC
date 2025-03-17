
#include <cassert>

#include "Metal_CPP_Header.h"
#include "MyAppDelegate.h"

int main(int argc, char *argv[]) {
    NS::AutoreleasePool *pAutoreleasePool = NS::AutoreleasePool::alloc()->init();

    MyAppDelegate del;

    NS::Application *pSharedApplication = NS::Application::sharedApplication();
    pSharedApplication->setDelegate(&del);
    pSharedApplication->run();

    pAutoreleasePool->release();

    return 0;
}
