-- Generated by CSharp.lua Compiler 1.0.0.0
local System = System;
local CSharpLuaLuaAst;
System.usingDeclare(function (global) 
    CSharpLuaLuaAst = CSharpLua.LuaAst;
end);
System.namespace("CSharpLua.LuaAst", function (namespace) 
    namespace.class("LuaIfStatementSyntax", function (namespace) 
        local getIfKeyword, getOpenParenToken, getCloseParenToken, Render, __init__, __ctor__;
        getIfKeyword = function (this) 
            return "if" --[[Keyword.If]];
        end;
        getOpenParenToken = function (this) 
            return "then" --[[Keyword.Then]];
        end;
        getCloseParenToken = function (this) 
            return "end" --[[Keyword.End]];
        end;
        Render = function (this, renderer) 
            renderer:Render40(this);
        end;
        __init__ = function (this) 
            this.Body = CSharpLuaLuaAst.LuaBlockSyntax();
            this.ElseIfStatements = CSharpLuaLuaAst.LuaSyntaxList_1(CSharpLuaLuaAst.LuaElseIfStatementSyntax)();
        end;
        __ctor__ = function (this, condition) 
            __init__(this);
            if condition == nil then
                System.throw(System.ArgumentNullException("condition"));
            end
            this.Condition = condition;
        end;
        return {
            __inherits__ = {
                CSharpLuaLuaAst.LuaStatementSyntax
            }, 
            getIfKeyword = getIfKeyword, 
            getOpenParenToken = getOpenParenToken, 
            getCloseParenToken = getCloseParenToken, 
            Render = Render, 
            __ctor__ = __ctor__
        };
    end);
    namespace.class("LuaElseIfStatementSyntax", function (namespace) 
        local getElseIfKeyword, getOpenParenToken, Render, __init__, __ctor__;
        getElseIfKeyword = function (this) 
            return "elseif" --[[Keyword.ElseIf]];
        end;
        getOpenParenToken = function (this) 
            return "then" --[[Keyword.Then]];
        end;
        Render = function (this, renderer) 
            renderer:Render41(this);
        end;
        __init__ = function (this) 
            this.Body = CSharpLuaLuaAst.LuaBlockSyntax();
        end;
        __ctor__ = function (this, condition) 
            __init__(this);
            if condition == nil then
                System.throw(System.ArgumentNullException("condition"));
            end
            this.Condition = condition;
        end;
        return {
            __inherits__ = {
                CSharpLuaLuaAst.LuaStatementSyntax
            }, 
            getElseIfKeyword = getElseIfKeyword, 
            getOpenParenToken = getOpenParenToken, 
            Render = Render, 
            __ctor__ = __ctor__
        };
    end);
    namespace.class("LuaElseClauseSyntax", function (namespace) 
        local getElseKeyword, Render, __ctor__;
        getElseKeyword = function (this) 
            return "else" --[[Keyword.Else]];
        end;
        Render = function (this, renderer) 
            renderer:Render42(this);
        end;
        __ctor__ = function (this) 
            this.Body = CSharpLuaLuaAst.LuaBlockSyntax();
        end;
        return {
            __inherits__ = {
                CSharpLuaLuaAst.LuaSyntaxNode
            }, 
            getElseKeyword = getElseKeyword, 
            Render = Render, 
            __ctor__ = __ctor__
        };
    end);
    namespace.class("LuaSwitchAdapterStatementSyntax", function (namespace) 
        local Fill, CheckHasDefaultLabel, FindMatchIfStatement, CheckHasCaseLabel, Render, __init__, __ctor__;
        Fill = function (this, expression, sections) 
            if expression == nil then
                System.throw(System.ArgumentNullException("expression"));
            end
            if sections == nil then
                System.throw(System.ArgumentNullException("sections"));
            end

            local body = this.RepeatStatement.Body;
            body.Statements:Add1(this.caseLabelVariables_);
            body.Statements:Add1(CSharpLuaLuaAst.LuaLocalVariableDeclaratorSyntax:new(2, this.Temp, expression));

            local ifStatement = nil;
            for _, section in System.each(sections) do
                local statement = System.as(section, CSharpLuaLuaAst.LuaIfStatementSyntax);
                if statement ~= nil then
                    if ifStatement == nil then
                        ifStatement = statement;
                    else
                        local elseIfStatement = CSharpLuaLuaAst.LuaElseIfStatementSyntax(statement.Condition);
                        elseIfStatement.Body.Statements:AddRange1(statement.Body.Statements);
                        ifStatement.ElseIfStatements:Add1(elseIfStatement);
                    end
                else
                    assert(this.defaultBock_ == nil);
                    this.defaultBock_ = System.cast(CSharpLuaLuaAst.LuaBlockSyntax, section);
                end
            end

            if ifStatement ~= nil then
                body.Statements:Add1(ifStatement);
                if this.defaultBock_ ~= nil then
                    local elseClause = CSharpLuaLuaAst.LuaElseClauseSyntax();
                    elseClause.Body.Statements:AddRange1(this.defaultBock_.Statements);
                    ifStatement.Else = elseClause;
                end
                this.headIfStatement_ = ifStatement;
            else
                if this.defaultBock_ ~= nil then
                    body.Statements:AddRange1(this.defaultBock_.Statements);
                end
            end
        end;
        CheckHasDefaultLabel = function (this) 
            if this.DefaultLabel ~= nil then
                assert(this.defaultBock_ ~= nil);
                this.caseLabelVariables_.Variables:Add1(this.DefaultLabel);
                local labeledStatement = CSharpLuaLuaAst.LuaLabeledStatement(this.DefaultLabel, nil);
                this.RepeatStatement.Body.Statements:Add1(labeledStatement);
                local IfStatement = CSharpLuaLuaAst.LuaIfStatementSyntax(this.DefaultLabel);
                IfStatement.Body.Statements:AddRange1(this.defaultBock_.Statements);
                this.RepeatStatement.Body.Statements:Add1(IfStatement);
            end
        end;
        FindMatchIfStatement = function (this, index) 
            if index == 0 then
                return this.headIfStatement_.Body;
            else
                return this.headIfStatement_.ElseIfStatements:get(index - 1).Body;
            end
        end;
        CheckHasCaseLabel = function (this) 
            if this.CaseLabels:getCount() > 0 then
                assert(this.headIfStatement_ ~= nil);
                this.caseLabelVariables_.Variables:AddRange1(this.CaseLabels:getValues());
                for _, pair in System.each(this.CaseLabels) do
                    local caseLabelStatement = FindMatchIfStatement(this, pair:getKey());
                    local labelIdentifier = pair:getValue();
                    this.RepeatStatement.Body.Statements:Add1(CSharpLuaLuaAst.LuaLabeledStatement(labelIdentifier, nil));
                    local ifStatement = CSharpLuaLuaAst.LuaIfStatementSyntax(labelIdentifier);
                    ifStatement.Body.Statements:AddRange1(caseLabelStatement.Statements);
                    this.RepeatStatement.Body.Statements:Add1(ifStatement);
                end
            end
        end;
        Render = function (this, renderer) 
            CheckHasCaseLabel(this);
            CheckHasDefaultLabel(this);
            renderer:Render47(this);
        end;
        __init__ = function (this) 
            this.RepeatStatement = CSharpLuaLuaAst.LuaRepeatStatementSyntax(CSharpLuaLuaAst.LuaIdentifierNameSyntax.One);
            this.caseLabelVariables_ = CSharpLuaLuaAst.LuaLocalVariablesStatementSyntax();
            this.CaseLabels = System.Dictionary(System.Int, CSharpLuaLuaAst.LuaIdentifierNameSyntax)();
        end;
        __ctor__ = function (this, temp) 
            __init__(this);
            this.Temp = temp;
        end;
        return {
            __inherits__ = {
                CSharpLuaLuaAst.LuaStatementSyntax
            }, 
            Fill = Fill, 
            Render = Render, 
            __ctor__ = __ctor__
        };
    end);
    namespace.class("LuaMethodParameterDefaultValueStatementSyntax", function (namespace) 
        local getIfKeyword, getOpenParenToken, getCloseParenToken, Render, __ctor__;
        getIfKeyword = function (this) 
            return "if" --[[Keyword.If]];
        end;
        getOpenParenToken = function (this) 
            return "then" --[[Keyword.Then]];
        end;
        getCloseParenToken = function (this) 
            return "end" --[[Keyword.End]];
        end;
        Render = function (this, renderer) 
            renderer:Render48(this);
        end;
        __ctor__ = function (this, parameter, defaultValue) 
            if parameter == nil then
                System.throw(System.ArgumentNullException("parameter"));
            end
            if defaultValue == nil then
                System.throw(System.ArgumentNullException("defaultValue"));
            end
            this.Condition = CSharpLuaLuaAst.LuaBinaryExpressionSyntax(parameter, "==" --[[Tokens.EqualsEquals]], CSharpLuaLuaAst.LuaIdentifierNameSyntax.Nil);
            this.Assignment = CSharpLuaLuaAst.LuaAssignmentExpressionSyntax(parameter, defaultValue);
        end;
        return {
            __inherits__ = {
                CSharpLuaLuaAst.LuaStatementSyntax
            }, 
            getIfKeyword = getIfKeyword, 
            getOpenParenToken = getOpenParenToken, 
            getCloseParenToken = getCloseParenToken, 
            Render = Render, 
            __ctor__ = __ctor__
        };
    end);
end);
