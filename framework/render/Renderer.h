
#pragma once

#include <Metal/Metal.hpp>
#include <AppKit/AppKit.hpp>
#include <MetalKit/MetalKit.hpp>

class Renderer {
public:
    Renderer(MTL::Device *pDevice);
    ~Renderer();
    void buildShaders();
    void buildBuffers();
    void draw(MTK::View *pView);

private:
    MTL::Device *_pDevice;
    MTL::CommandQueue *_pCommandQueue;
    MTL::RenderPipelineState *_pPSO;
    MTL::Buffer *_pVertexPositionsBuffer;
    MTL::Buffer *_pVertexColorsBuffer;
};

class MyMTKViewDelegate : public MTK::ViewDelegate {
public:
    MyMTKViewDelegate(MTL::Device *pDevice);
    virtual ~MyMTKViewDelegate() override;
    virtual void drawInMTKView(MTK::View *pView) override;

private:
    Renderer *_pRenderer;
};
