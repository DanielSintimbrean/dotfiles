yay.create_autocmd("UpgradeSelect", {
    desc = "skip recently modified AUR upgrades",
    callback = function(event)
        local exclude = {}
        local recent_cutoff = os.time() - (3 * 24 * 60 * 60)

        for _, pkg in ipairs(event.data.upgrades) do
            if pkg.repository == "aur" and pkg.last_modified >= recent_cutoff then
                table.insert(exclude, pkg.name)
            end
        end

        return { exclude = exclude, skip_menu = false }
    end,
})
