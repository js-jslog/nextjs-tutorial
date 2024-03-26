'use server';

export async function createInvoice(formData: FormData) {
  const rawFormData = Object.fromEntries(formData.entries())
  console.log(rawFormData);
}
