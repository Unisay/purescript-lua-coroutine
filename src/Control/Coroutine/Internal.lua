return {
    create = function(f)
        return function()
            local r = coroutine.create(function(i) return f(i)() end)
            return r
        end
    end,
    yield = function(o)
        return function()
            return coroutine.yield(o)
        end
    end,
    resume = function(c)
        return function(i)
            return function(onYield)
                return function(onError)
                    return function()
                        local res, out = coroutine.resume(c, i)
                        if res then return onYield(out)
                        else return onError(out) end
                    end
                end
            end
        end
    end,
    running = function()
        return coroutine.running()
    end,
    status = function(c)
        return function()
            return coroutine.status(c)
        end
    end,
}
