//
//  OpenGLES_Ch3_1ViewController.m
//  OpenGLES_Ch3_1
//

#import "OpenGLES_Ch3_1ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

@implementation OpenGLES_Ch3_1ViewController

@synthesize baseEffect;
@synthesize vertexBuffer;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
   GLKVector3  positionCoords;
   GLKVector2  textureCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
//static const SceneVertex vertices[] = 
//{
//   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
//   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
//   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
//};

static const SceneVertex vertices[] =
{
   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
    {{0.5f, 0.5f, 0.0f}, {1.0f, 1.0f}}, // upper right corner
};


/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Verify the type of view created automatically by the
   // Interface Builder storyboard
   GLKView *view = (GLKView *)self.view;
   NSAssert([view isKindOfClass:[GLKView class]],
      @"View controller's view is not a GLKView");
   
   // Create an OpenGL ES 2.0 context and provide it to the
   // view
   view.context = [[AGLKContext alloc] 
      initWithAPI:kEAGLRenderingAPIOpenGLES2];
   
   // Make the new context current
   [AGLKContext setCurrentContext:view.context];
   
   // Create a base effect that provides standard OpenGL ES 2.0
   // shading language programs and set constants to be used for 
   // all subsequent rendering
   self.baseEffect = [[GLKBaseEffect alloc] init];
   self.baseEffect.useConstantColor = GL_TRUE;
   self.baseEffect.constantColor = GLKVector4Make(
      1.0f, // Red
      1.0f, // Green
      1.0f, // Blue
      1.0f);// Alpha
   
   // Set the background color stored in the current context 
   ((AGLKContext *)view.context).clearColor = GLKVector4Make(
      0.0f, // Red 
      0.0f, // Green 
      0.0f, // Blue 
      1.0f);// Alpha 
   
   // Create vertex buffer containing vertices to draw
   self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
      initWithAttribStride:sizeof(SceneVertex)
      numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
      bytes:vertices
      usage:GL_STATIC_DRAW];
   
   // Setup texture
   CGImageRef imageRef = 
      [[UIImage imageNamed:@"leaves.gif"] CGImage];
      
   GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef
                                                              options:nil
                                                                error:NULL];
   
   self.baseEffect.texture2d0.name = textureInfo.name;
   self.baseEffect.texture2d0.target = textureInfo.target;
}


/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
   
   // Clear back frame buffer (erase previous drawing)
   [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
   
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
      numberOfCoordinates:3
      attribOffset:offsetof(SceneVertex, positionCoords)
      shouldEnable:YES];
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
      numberOfCoordinates:2
      attribOffset:offsetof(SceneVertex, textureCoords)
      shouldEnable:YES];
      
   // Draw triangles using the first three vertices in the 
   // currently bound vertex buffer
   [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:6];
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view 
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [AGLKContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   self.vertexBuffer = nil;
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}

@end
