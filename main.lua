local SP = "j_dp_"

local jokers = {
    jeroen = {
        sprite = SP .. "jeroen",
        rarity = 1,
        cost = 2,
        blueprint_compat = true,

        --[[
        Config sets all the variables for your card, you want to put all numbers here.
        This is really useful for scaling numbers, but should be done with static numbers -
            If you want to change the static value, you'd only change this number, instead
            of going through all your code to change each instance individually.
        ]]
        config = { extra = { Xmult = 2 } },

        loc_txt = {
            name = "Jeroen",
            text = {
                --[[
                The #1# is a variable that's stored in config, and is put into loc_vars.
                The {C:} is a color modifier, and uses the color "mult" for the "+#1# " part, and then the empty {} is to reset all formatting, so that Mult remains uncolored.
                There's {X:}, which sets the background, usually used for XMult.
                There's {s:}, which is scale, and multiplies the text size by the value, like 0.8
                There's one more, {V:1}, but is more advanced, and is used in Castle and Ancient Jokers. It allows for a variable to dynamically change the color, but is very rarely used.
                Multiple variables can be used in one space, as long as you separate them with a comma. {C:attention, X:chips, s:1.3} would be the yellow attention color, with a blue chips-colored background,, and 1.3 times the scale of other text.
                You can find the vanilla joker descriptions and names as well as several other things in the localization files.
                ]]
                -- "{C:mult}+#1# {} Mult"
                "{X:mult,C:white} X#1# {} Mult",
                "for every {C:attention}2{}",
                "in poker hand",
            }
        },
        -- loc_vars gives your loc_text variables to work with, in the format of #n#, n being the variable in order.
        -- #1# is the first variable in vars, #2# the second, #3# the third, and so on.
        -- It's also where you'd add to the info_queue, which is where things like the negative tooltip are.
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult } }
        end,

        -- x2 Mult for every 2 in played hand
        calculate = function(self, card, context)
            if context.joker_main then
                local acc = 0

                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 2 then
                        acc = acc + card.ability.extra.Xmult
                    end
                end

                if acc > 0 then
                    return {
                        Xmult_mod = acc,
                        message = localize { type = 'variable', key = 'a_xmult', vars = { acc } },
                    }
                end
            end
        end
    },

    jimbo_van_oranje = {
        sprite = SP .. "jimbovanoranje",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        config = { extra = { mult = 2 } },

        loc_txt = {
            name = "Jimbo van Oranje",
            text = {
                "{C:mult}+#1#{} Mult for every",
                "{C:diamonds}King of Diamonds{}",
                "held in hand"
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,

        -- +4 Mult for every King of Diamonds held in hand
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.hand and context.other_card:get_id() == 13 and context.other_card:is_suit("Diamonds") then
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
                }
            end
        end
    },

    papal_joker = {
        sprite = SP .. "papaljoker",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        config = { extra = { mult = 21, chips = 37, odds = 4 } },

        loc_txt = {
            name = "Papal Joker",
            text = {
                "{C:green}#1# in #2#{} chance for",
                "{C:mult}+#3#{} Mult and {C:chips}+#4#{} Chips"
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.mult, card.ability.extra.chips } }
        end,

        -- 1 in a 4 chance for +21 Mult and +37 Chips
        calculate = function(self, card, context)
            if context.joker_main then
                if pseudorandom('papal_joker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    return {
                        message = "Okrutnik!",
                        mult_mod = card.ability.extra.mult,
                        chip_mod = card.ability.extra.chips,
                        colour = G.C.MULT,
                    }
                end
            end
        end
    },

    amsterdamse_joker = {
        sprite = SP .. "amsterdamsejoker",
        rarity = 1,
        blueprint_compat = true,
        cost = 2,

        config = { extra = { mult = 4, chips = 20 } },

        loc_txt = {
            name = "Amsterdamse Joker",
            text = {
                "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                "for every {C:clubs}4 of Clubs{} played"
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
        end,

        -- +4 mult and +20 chips for every 4 of Clubs played
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 4 and context.other_card:is_suit("Clubs") then
                    return {
                        mult = card.ability.extra.mult,
                        chips = card.ability.extra.chips,
                        card = context.other_card
                    }
                end
            end
        end
    },

    food_delivery = {
        name = "Food Delivery",
        sprite = SP .. "fooddelivery",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        -- Retrigger all face cards played during Boss Blind

        -- TODO

    },

    nijntje = {
        name = "Nijntje",
        sprite = SP .. "nijntje",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        -- Add +1 Mult for every failed Wheel of Fortune

        -- TODO

    },

    jo_ker = {
        name = "Jo(ker)",
        sprite = SP .. "jo-ker",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        -- 1 in a 20 chance to level up all poker hands after a round

        -- TODO

    },

    jester_klein = {
        name = "Jester Klein",
        sprite = SP .. "jesterklein",
        rarity = 2,
        blueprint_compat = true,
        cost = 4,

        -- Retrigger all Diamond cards

        -- TODO

    },

    efficient_budgeting = {
        name = "Efficient Budgeting",
        sprite = SP .. "efficientbudgeting",
        rarity = 3,
        blueprint_compat = true,
        cost = 8,

        -- -30$ for every played ace, x5 Mult

        -- TODO

    }
}

for joker_id, joker_def in pairs(jokers) do
    if joker_def.sprite ~= nil then
        local sprite = joker_def.sprite

        SMODS.Atlas {
            key = sprite,
            path = sprite .. ".png",
            px = 71,
            py = 97
        }

        joker_def.sprite = nil
        joker_def.atlas = sprite
        joker_def.pos = { x = 0, y = 0 }
    end

    joker_def.key = joker_id

    SMODS.Joker(joker_def)
end
