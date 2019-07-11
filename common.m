#include <stdio.h>
#include <stdlib.h>
#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/lauxlib.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static int alert(lua_State *L)
{
    size32_t l;
    const char * msg = luaL_checklstring(L, 1, &l);
    NSString *message = [NSString stringWithUTF8String:msg];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    });
    return 0;
}

static int getScreenResolution(lua_State *L)
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat scale = screen.scale;
    lua_pushinteger(L, screen.bounds.size.width * scale);
    lua_pushinteger(L, screen.bounds.size.height * scale);
    return 2;
}

// Regsiter the function
static const luaL_Reg extensions[] = {
    {"alert", alert},
    {"getScreenResolution", getScreenResolution},
    {NULL, NULL}
};

/**
 * Use in Lua like this
 * 
 * ```lua
 * local common = require "common"
 * 
 * common.alert("Hello World!")
 * 
 * local w, h = common.getScreenResolution();
 * common.alert(string.format("Resolution of iPhone 6 Plus: width:%d, height:%d", w, h));
 * ```
 */
int luaopen_common(lua_State *L)
{
    luaL_newlib(L, extensions);
    return 1;
}