
#pragma once

#include <Metal/Metal.hpp>
#include <AppKit/AppKit.hpp>
#include <MetalKit/MetalKit.hpp>

#include "Renderer.h"

#pragma region Declarations {
class MyAppDelegate : public NS::ApplicationDelegate {
public:
    ~MyAppDelegate();

    NS::Menu *createMenuBar();

    virtual void applicationWillFinishLaunching(NS::Notification *pNotification) override;
    virtual void applicationDidFinishLaunching(NS::Notification *pNotification) override;
    virtual bool applicationShouldTerminateAfterLastWindowClosed(NS::Application *pSender) override;

private:
    NS::Window *_pWindow;
    MTK::View *_pMtkView;
    MTL::Device *_pDevice;
    MyMTKViewDelegate *_pViewDelegate = nullptr;
};

#pragma endregion Declarations }
