// This is the interface for the permission data
export interface Permission {
    id?: number;
    text: string;
}

/**
 * A service that performs CrUD an retrieval on permissions.
 */
 export class PermissionsController {
    permissions: Permission[] = [];

    async find () {
        // Just return all our permissions
        return this.permissions;
    }

    async create (data: Pick<Permission, 'text'>) {
        // The new permission is the data text with a unique identifier added
        // using the permissions length since it changes whenever we add one
        const permission: Permission = {
            id: this.permissions.length,
            text: data.text
        }

        // Add new permission to the list
        this.permissions.push(permission);

        return permission;
    }
}
