'use server';

import { sql } from '@vercel/postgres';
import { z } from 'zod';
import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

const FormSchema = z.object({
  id: z.string(),
  customerId: z.string(),
  amount: z.coerce.number(),
  status: z.enum(['pending', 'paid']),
  date: z.string(),
});

const CreateInvoice = FormSchema.omit({ id: true, date: true });

export async function createInvoice(formData: FormData) {
  let customerId: string
  let amount: number
  let status: string
  try {
    const { customerId: customerIdTry, amount: amountTry, status: statusTry } = CreateInvoice.parse(Object.fromEntries(formData.entries()));
    customerId = customerIdTry
    amount = amountTry
    status = statusTry
  } catch (e) {
    return {
      message: `Validation error: Failed to create invoice - ${e}`
    }
  }
  const amountInCents = amount * 100
  const date = new Date().toISOString().split('T')[0];

  try {
    await sql`
    INSERT INTO invoices (customer_id, amount, status, date)
    VALUES (${customerId}, ${amountInCents}, ${status}, ${date})
    `;

    revalidatePath('/dashboard/invoices');
    redirect('/dashboard/invoices');
  } catch (e) {
    return {
      message: `Database error: Failed to create invoice - ${e}`
    }
  }
}

const UpdateInvoice = FormSchema.omit({ id: true, date: true });

export async function updateInvoice(id: string, formData: FormData) {
  let customerId: string
  let amount: number
  let status: string
  try {
    const { customerId: customerIdTry, amount: amountTry, status: statusTry } = UpdateInvoice.parse(Object.fromEntries(formData.entries()));
    customerId = customerIdTry
    amount = amountTry
    status = statusTry
  } catch (e) {
    return {
      message: `Validation error: Failed to update invoice - ${e}`
    }
  }

  const amountInCents = amount * 100;

  try {
    await sql`
    UPDATE invoices
    SET customer_id = ${customerId}, amount = ${amountInCents}, status = ${status}
    WHERE id = ${id}
    `;
  } catch (e) {
    return {
      message: `Database error: Failed to update invoice - ${e}`
    }
  }

  revalidatePath('/dashboard/invoices');
  redirect('/dashboard/invoices');
}

export async function deleteInvoice(id: string) {
  try {
    await sql`DELETE FROM invoices WHERE id = ${id}`;
  } catch (e) {
    return {
      message: `Database error: Failed to delete invoice - ${e}`
    }
  }
  revalidatePath('/dashboard/invoices');
}
